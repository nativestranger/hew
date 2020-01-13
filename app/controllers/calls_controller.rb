class CallsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_call, only: %i[applications show edit update]

  def new # TODO: unauthenticated user can create call
    @call = Call.new(is_public: true)
    ensure_venue
  end

  def create
    @call = Call.new(permitted_params.merge(user: current_user))

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
    @call_user = @call.call_users.find_by!(user: current_user)
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
    # TODO: render homepage search for unauthenticated?
    redirect_to dashboard_path
  end

  def applications
    authorize @call, :show?

    @call_user = @call.call_users.find_by!(user: current_user)

    @search_categories = \
      @call_user.category_restrictions.presence || @call.categories

    category_ids = @search_categories.pluck(:id)
    status_ids = []

    if params[:entry_searcher]
      category_ids = params[:entry_searcher][:category_ids].reject(&:blank?) if params[:entry_searcher][:category_ids]
      status_ids = params[:entry_searcher][:status_ids].reject(&:blank?)
    end

    - # TODO: filter from entry_searcher category_ids from @search_categories
    - # similar for status_ids - set up whitelist per role

    creation_statuses = ['submitted']

    @entry_searcher = EntrySearcher.new(
      call_id: @call.id,
      category_ids: category_ids,
      status_ids: status_ids,
      creation_statuses: creation_statuses,
    )

    @applications = @entry_searcher.records
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
      @call&.venue&.user ||= current_user
      @call.save!
      @call.call_users.create!(user: current_user, role: 'owner')
    rescue ActiveRecord::RecordInvalid => e
      raise ActiveRecord::Rollback
    end
  end

  def update_call
    Call.transaction do
      @call.call_category_users.where.not(
        call_categories: { category_id: permitted_params[:category_ids]  }
      ).each(&:destroy!)

      @call.assign_attributes(permitted_params)
      @call&.venue&.user ||= current_user
      @call.save!(permitted_params)
    rescue ActiveRecord::RecordInvalid => e
      raise ActiveRecord::Rollback
    end
  end
end
