class CallSearcher
  def initialize(params)
    @call_name = params[:call_name]
    @user = params[:user]
    @call_type_ids = params[:call_type_ids]
    @spiders = params[:spiders]
    @order_option = params[:order_option]
    @approved = params[:approved]
    @published = params[:published]
    @start_at_start = params[:start_at_start]
    @entry_deadline_start = params[:entry_deadline_start]
    @entry_deadline_end = params[:entry_deadline_end]
    @entry_fee_start = params[:entry_fee_start]
    @entry_fee_end = params[:entry_fee_end]
    @include_no_fee = @entry_fee_start&.to_i == 0

    @calls = Call.all.distinct
  end

  def records
    if @call_type_ids&.any?
      @calls = @calls.where(call_type_id: @call_type_ids)
    end

    if @spiders&.any?
      @calls = @calls.where(spider: @spiders)
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

    if @start_at_start
      @calls = @calls.where("start_at >= ?", @start_at_start)
    end

    if @entry_deadline_start
      @calls = @calls.where("entry_deadline >= ?", @entry_deadline_start)
    end

    if @entry_deadline_end
      @calls = @calls.where("entry_deadline <= ?", @entry_deadline_end)
    end

    if fee_range?
      if @include_no_fee
        @calls = @calls.where(entry_fee: nil).or(fee_range_calls)
      else
        @calls = fee_range_calls
      end
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

  def fee_range?
    @entry_fee_start || @entry_fee_end
  end

  def fee_range_calls
    return unless fee_range?

    result = @calls

    if @entry_fee_start
      result = result.where("entry_fee >= ?", @entry_fee_start.to_i)
    end

    if @entry_fee_end
      result = result.where("entry_fee <= ?", @entry_fee_end.to_i)
    end

    result
  end
end
