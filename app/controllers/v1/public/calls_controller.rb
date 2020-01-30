class V1::Public::CallsController < V1Controller
  def index
    @calls = CallSearcher.new(params).records

    render json: paginate(@calls, serializer: CallSerializer)
  end

  def update
    @call = Call.find(params[:id])
    @call.increment!(:view_count)
    render json: {}
  end
end
