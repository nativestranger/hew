class V1::CallsController < V1Controller
  before_action :authenticate_user!

  def index
    @calls = CallSearcher.new(
      call_name: params[:name],
      spiders: params[:spiders],
      call_type_ids: params[:call_type_ids],
      order_option: params[:order_option],
      entry_deadline_start: params[:entry_deadline_start],
      user: current_user
    ).records

    render json: paginate(@calls, serializer: CallSerializer)
  end

  private
end
