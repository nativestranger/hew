class EntrySearcher < ActiveModel::Serializer
  attr_accessor :category_ids, :status_ids

  def initialize(params)
    @call_id = params[:call_id].presence || raise # need to allow admin
    @category_ids = params[:category_ids]
    @status_ids = params[:status_ids]

    @call_applications = CallApplication.all.distinct
  end

  def records
    if @call_id
      @call_applications = @call_applications.where(call_id: @call_id)
    end

    if @category_ids&.any?
      @call_applications = @call_applications.where(category_id: @category_ids)
    end

    if @status_ids&.any?
      @call_applications = @call_applications.where(status_id: @status_ids)
    end

    @call_applications.order(order_option)
  end

  private

  def order_option
    case @order_option && @order_option[:name]
    when 'Newest'
      'call_applications.created_at DESC'
    when 'Updated'
      'call_applications.updated_at DESC'
    else
      'call_applications.id DESC'
    end
  end
end
