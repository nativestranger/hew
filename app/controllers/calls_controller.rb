class CallsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_call, only: %i[applications show edit update update_application_status]

  def new
    @call = Call.new(is_public: true)
    ensure_venue
  end

  def create
    @call = Call.new(permitted_params.merge(user: current_user))
    modify_venue_maybe

    if create_call
      AdminMailer.new_call(@call).deliver_later if @call.is_public
      redirect_to @call, notice: t('success')
    else
      ensure_venue
      render :new
    end
  end

  def show
    authorize @call
    @call_user = @call.call_users.find_by(user: current_user)

    case @call_user.role
    when 'juror'
      @call_applications = @call.applications.creation_status_submitted
    end
  end

  def edit
    authorize @call
    ensure_venue
  end

  def update
    authorize @call

    private_before_update = !@call.is_public

    if update_call
      AdminMailer.new_call(@call).deliver_later if @call.is_public && private_before_update
      redirect_to @call, notice: t('success')
    else
      ensure_venue
      render :edit
    end
  end

  def index
    redirect_to dashboard_path
  end

  def update_application_status
    authorize @call_application, :update_status?

    status = CallApplication.status_ids.find { |_k, v| v == params.fetch(:status_id).to_i }.first
    @call_application = @call.applications.find(params[:call_application_id])
    @call_application.update!(status_id: status)
    flash[:notice] = "Moved #{@call_application.user.full_name} to '#{status.capitalize}'."
    redirect_to call_applications_path(@call, helpers.curator_application_status_scope => true)
  end

  def applications
    authorize @call, :show?

    @applications = @call.applications.send(helpers.curator_application_status_scope)
  end

  private

  def permitted_params
    result = params.require(:call).permit(
      :name,
      :start_at,
      :end_at,
      :overview,
      :is_public,
      :external,
      :external_url,
      :call_type_id,
      :full_description,
      :application_details,
      :application_deadline,
      category_ids: [],
      venue_attributes: [
        :id,
        :name,
        :website,
        { address_attributes: %i[id city state country street_address street_address_2 postal_code] }
      ]
    )

    result[:category_ids] = result[:category_ids].dup.reject(&:blank?).map do |category_id|
      if /^\d+$/.match(category_id)
        category_id
      else
        Category.find_or_create_by!(name: category_id).id # TODO: lock or retry on race
      end
    end

    result
  end

  def modify_venue_maybe
    if @call.call_type_id_publication? || @call.call_type_id_competition? || @call.external? && @call.venue.attributes.slice('name', 'website').values.all?(&:blank?)
      @call.venue = nil
    else
      @call&.venue&.user ||= current_user
    end
  end

  def set_call
    @call = Call.find(params[:id])
  end

  def ensure_venue
    if @call.venue.blank?
      address = Address.new(city: 'Mexico City', state: 'Mexico City', country: 'MX')
      @venue = Venue.new(address: address)
      @call.venue = @venue
    end
  end

  def create_call
    Call.transaction do
      @call.save!
      @call.call_users.create!(user: current_user, role: 'owner')
    rescue ActiveRecord::RecordInvalid => e
      raise ActiveRecord::Rollback
    end
  end

  def update_call
    Call.transaction do
      modify_venue_maybe
      @call.call_category_users.where.not(
        call_categories: { category_id: permitted_params[:category_ids]  }
      ).each(&:destroy!)
      @call.update!(permitted_params)
    rescue ActiveRecord::RecordInvalid => e
      raise ActiveRecord::Rollback
    end
  end
end
