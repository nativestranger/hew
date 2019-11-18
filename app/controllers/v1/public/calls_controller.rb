class V1::Public::CallsController < V1Controller

  def index
    @calls = CallSearcher.new(params).records

    render json: {
      calls: @calls.map do |c|
        CallSerializer.new(c).serializable_hash
      end
    }
  end

end
