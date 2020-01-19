class EntrySearcher
  attr_accessor :category_ids, :status_ids

  def initialize(params)
    @call_id = params[:call_id].presence || raise # need to allow admin

    @creation_statuses = params[:creation_statuses]
    @category_ids = params[:category_ids]
    @status_ids = params[:status_ids]

    @entries = Entry.all.distinct
  end

  def records
    if @call_id
      @entries = @entries.where(call_id: @call_id)
    end

    if @category_ids&.any?
      @entries = @entries.where(category_id: @category_ids)
    end

    if @status_ids&.any?
      @entries = @entries.where(status_id: @status_ids)
    end

    if @creation_statuses&.any?
      @entries = @entries.where(creation_status: @creation_statuses)
    end

    @entries.order(order_option)
  end

  private

  def order_option
    case @order_option && @order_option[:name]
    when 'Newest'
      'entries.created_at DESC'
    when 'Updated'
      'entries.updated_at DESC'
    else
      'entries.updated_at DESC'
    end
  end
end
