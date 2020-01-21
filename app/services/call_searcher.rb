class CallSearcher
  def initialize(params)
    @call_name = params[:call_name]
    @user = params[:user]
    @call_type_ids = params[:call_type_ids]
    @order_option = params[:order_option]
    @approved = params[:approved]
    @published = params[:published]

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

      if [true, false].include?(@approved)
        @calls = @calls.where(is_approved: @approved)
      end

      if [true, false].include?(@published)
        @calls = @calls.where(is_public: @published)
      end
    else
      @calls = @calls.homepage
    end

    if @call_name
      @calls = @calls.where("name ILIKE :name", name: "%#{@call_name}%")
    end

    @calls.order(order_option)
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
