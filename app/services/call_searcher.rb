class CallSearcher < ActiveModel::Serializer
  attr_reader :call_type_ids

  def initialize(params)
    @call_type_ids = params[:call_type_ids]
    @order_option = params[:order_option]

    @calls = Call.all.distinct
  end

  def records
    @calls = @calls.where(call_type_id: call_type_ids)

    if !admin_search?
      @calls = @calls.accepting_applications.approved.published
    end

    @calls.order(order_option(@order_option))
  end

  private

  def order_option(options_str)
    case @order_option && @order_option[:name]
    when 'Deadline'
      'calls.application_deadline ASC'
    when 'Created'
      'calls.created_at DESC'
    else
      'calls.id DESC'
    end
  end

  def admin_search?
    false
  end
end
