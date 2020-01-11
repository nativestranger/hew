class CallSearcher < ActiveModel::Serializer
  def initialize(params)
    @call_name = params[:call_name]
    @user = params[:user]
    @call_type_ids = params[:call_type_ids]
    @order_option = params[:order_option]

    @calls = Call.all.distinct
  end

  def records
    if @call_type_ids
      @calls = @calls.where(call_type_id: @call_type_ids)
    end

    if @user
      @calls = @calls.joins(:call_users).where(
        call_users: { user_id: @user.id }
      )
    else
      @calls = @calls.accepting_applications.approved.published
    end

    if @call_name
      @calls = @calls.where("name ILIKE :name", name: "%#{@call_name}%")
    end

    @calls.order(order_option)
  end

  private

  def order_option
    case @order_option && @order_option[:name]
    when 'Deadline'
      'calls.application_deadline ASC'
    when 'Created'
      'calls.created_at DESC'
    when 'Updated'
      'calls.updated_at DESC'
    else
      'calls.id DESC'
    end
  end
end
