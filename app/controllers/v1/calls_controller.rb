class V1::CallsController < V1Controller
  before_action :authenticate_user!

  def index
    @calls = Call.joins(:call_users).
      where(call_users: { user_id: current_user.id }).
      order(updated_at: :desc)

    if params[:name]
      @calls = @calls.where("name ILIKE :name", name: "%#{params[:name]}%")
    end

    render json: {
      calls: ActiveModel::Serializer::CollectionSerializer.new(
          @calls,
          each_serializer: CallSerializer
      )
    }
  end

  private
end
