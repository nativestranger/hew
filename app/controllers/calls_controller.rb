class CallsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_call, only: %i[applications show edit update update_application_status]
  before_action :authorize_user!, except: %i[new create index]

  def new
    address = Address.new(city: 'Mexico City', state: 'Mexico City', country: 'MX')
    @venue = Venue.new(address: address)
    @call = Call.new(venue: @venue, is_public: true)
  end

  def create
    @call = Call.new(permitted_params.merge(user: current_user))
    @call&.venue&.user ||= current_user

    if @call.save
      AdminMailer.new_call(@call).deliver_later if @call.is_public
      redirect_to @call, notice: t('success')
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    private_before_update = !@call.is_public

    if @call.update(permitted_params)
      AdminMailer.new_call(@call).deliver_later if @call.is_public && private_before_update
      redirect_to @call, notice: t('success')
    else
      render :edit
    end
  end

  def index
    redirect_to dashboard_path
  end

  def update_application_status
    status = CallApplication.status_ids.find { |_k, v| v == params.fetch(:status_id).to_i }.first
    @call_application = @call.applications.find(params[:call_application_id])
    @call_application.update!(status_id: status)
    flash[:notice] = "Moved #{@call_application.user.full_name} to '#{status.capitalize}'."
    redirect_to call_applications_path(@call, helpers.curator_application_status_scope => true)
  end

  def applications
    @applications = @call.applications.send(helpers.curator_application_status_scope)
  end

  private

  def permitted_params
    params.require(:call).permit(
      :name,
      :start_at,
      :end_at,
      :overview,
      :is_public,
      :external,
      :external_url,
      :full_description,
      :application_details,
      :application_deadline,
      venue_attributes: [
        :id,
        :name,
        :website,
        { address_attributes: %i[id city state country street_address street_address_2 postal_code] }
      ]
    )
  end

  def set_call
    @call = Call.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path unless current_user.id == @call.user_id
  end
end
