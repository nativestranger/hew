class CallsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_call, only: %i[entries entry update_entry show edit update scrape]

  def new # TODO: unauthenticated user can create call
    @call = Call.new(is_public: true, time_zone: current_user.time_zone)
    ensure_venue
  end

  def create
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
    @disable_turbolinks = true # for select2. consider disabling turbolink on all back/forward?
  end

  def update
    authorize @call

    private_before_update = !@call.is_public

    if update_call
      AdminMailer.new_call(@call).deliver_later if @call.is_public && private_before_update
      redirect_to @call
    else
      ensure_venue
      render :edit
    end
  end

  def index
    # TODO: render homepage search for unauthenticated?
  end

  def entries
    authorize @call, :view_entries?

    @disable_turbolinks = true

    @call_user = @call.call_users.find_by!(user: current_user)

    @search_categories = \
      @call_user.category_restrictions.presence || @call.categories

    category_ids = @search_categories.pluck(:id)
    status_ids = []

    if params[:entry_searcher]
      category_ids = params[:entry_searcher][:category_ids].reject(&:blank?) if params[:entry_searcher][:category_ids]
      status_ids = params[:entry_searcher][:status_ids].reject(&:blank?)
    end

    # TODO: filter from entry_searcher category_ids from @search_categories
    # similar for status_ids - set up whitelist per role


    creation_statuses = ['submitted']

    @entry_searcher = EntrySearcher.new(
      call_id: @call.id,
      category_ids: category_ids,
      status_ids: status_ids,
      creation_statuses: creation_statuses,
    )

    @entries = @entry_searcher.records
  end

  def entry
    authorize @call, :view_entries?
    @entry = @call.entries.find(params[:entry_id])

    # TODO: new how to authorize for use cases? # apply_scope?
    raise 'unauthorized' unless @entry.creation_status_submitted?
  end

  def update_entry
    authorize @call, :update_entry_status?
    @entry = @call.entries.find(params[:entry_id])

    # TODO: new how to authorize for use cases? # apply_scope?
    raise 'unauthorized' unless @entry.creation_status_submitted?

    entry_params = params.require(:entry).permit(:status_id)

    if @entry.update(entry_params)
      redirect_to call_entries_path(@call)
    else
      # TODO: error msg
      redirect_to call_entry_path(id: @call.id, entry_id: @entry.id), danger: 'oops'
    end
  end

  def scrape
    raise 'auth' unless current_user.is_admin?

    @call.scrape
    redirect_to @call, notice: 'Scraping'
  end

  private

  def permitted_params
    result = params.require(:call).permit(
      :name,
      :start_at,
      :end_at,
      :is_public,
      :external,
      :time_zone,
      :is_approved,
      :external_url,
      :call_type_id,
      :description,
      :entry_details,
      :entry_deadline,
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

    result.delete(:is_approved) unless current_user.is_admin?

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
      @call = Call.new(
        permitted_params.merge(
          user: current_user
        )
      )
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
      @call.save!
    rescue ActiveRecord::RecordInvalid => e
      raise ActiveRecord::Rollback
    end
  end
end
