class CallSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id,
             :name,
             :overview,
             :call_type,
             :time_until_deadline_in_words

  def call_type
    { name: object.call_type_id }
  end

  def time_until_deadline_in_words
    distance_of_time_in_words(Time.current, object.application_deadline)
  end
end
