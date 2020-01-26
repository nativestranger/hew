class V1::CallsController < V1Controller
  before_action :authenticate_user!

  def index
    @calls = CallSearcher.new(
      params.merge(user: current_user)
    ).records

    render json: paginate(@calls, serializer: CallSerializer)
  end

  private
end
