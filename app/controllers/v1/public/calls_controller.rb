class V1::Public::CallsController < V1Controller

  def index
    @calls = CallSearcher.new(params).records

    render json: paginate(@calls, serializer: CallSerializer)
  end

end
