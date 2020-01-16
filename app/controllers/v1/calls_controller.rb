class V1::CallsController < V1Controller
  before_action :authenticate_user!

  def index
    @calls = CallSearcher.new(
      call_name: params[:name],
      order_option: params[:order_option],
      user: current_user
    ).records

    render json: {
      calls: ActiveModel::Serializer::CollectionSerializer.new(
          @calls,
          each_serializer: CallSerializer
      )
    }
  end

  private
end
