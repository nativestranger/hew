class CallSearcher < ActiveModel::Serializer
  attr_reader :call_type_ids

  def initialize(params)
    @call_type_ids = params[:call_type_ids]

    @calls = Call.all.order(id: :asc)
  end

  def records
    @calls = @calls.where(call_type_id: call_type_ids)

    @calls.distinct
  end
end
