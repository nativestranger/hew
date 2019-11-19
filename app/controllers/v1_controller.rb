# frozen_string_literal: true

class V1Controller < ActionController::Base
  private

  def paginate(scope, default_per_page: 20, serializer: nil)
    collection = scope.page(params[:page]).per((params[:per_page] || default_per_page).to_i)

    current, total, per_page = collection.current_page, collection.total_pages, collection.limit_value

    if serializer
      records = collection.map { |r| serializer.new(r).serializable_hash }
    else
      records = collection
    end

    return {
      records: records,
      pagination: {
        current:  current,
        previous: (current > 1 ? (current - 1) : nil),
        next:     (current == total ? nil : (current + 1)),
        per_page: per_page,
        pages:    total,
        count:    collection.total_count
      }
    }
  end
end
