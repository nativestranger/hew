class CallSearcher < BaseSearch
  def initialize(params)
    @call_name = params[:call_name]
    @user = params[:user]
    @call_type_ids = params[:call_type_ids]
    @order_option = params[:sort]
    super(params)

    @calls = Call.all.distinct
  end

  def records
    if @call_type_ids&.any?
      @calls = @calls.where(call_type_id: @call_type_ids)
    end

    if @user
      @calls = @calls.joins(:call_users).where(
        call_users: { user: @user }
      )
    else
      @calls = @calls.accepting_entries.approved.published
    end

    if @call_name
      @calls = @calls.where("name ILIKE :name", name: "%#{@call_name}%")
    end

    # @calls.order(order_option)
    sort_query(@calls)
  end

  def sort_columns
    columns = [
      { label: 'Deadline (soonest)' , column: 'calls.entry_deadline', direction: 'asc' },
      { label: 'Deadline (furthest)', column: 'calls.entry_deadline', direction: 'desc' },
      { label: 'Newest', column: 'calls.created_at', direction: 'desc', default: true },
      { label: 'Updated', column: 'calls.updated_at', direction: 'desc' }
    ]

    columns
  end

  private

  def order_option
    case @order_option && @order_option[:name]
    when 'Deadline (soonest)'
      'calls.entry_deadline ASC'
    when 'Deadline (furthest)'
      'calls.entry_deadline DESC'
    when 'Newest'
      'calls.created_at DESC'
    when 'Updated'
      'calls.updated_at DESC'
    else
      'calls.id DESC'
    end
  end
end
