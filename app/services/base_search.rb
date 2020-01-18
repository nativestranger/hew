class BaseSearch
  attr_reader :params, :sort_column, :sort_direction

  def initialize(params)
    @params = params
    @sort_column = set_sort_column
    @sort_direction = set_sort_direction
  end

  private

    def sort_query(query)
      sort_clause = @sort_column.split(',').map { |item| item.strip + ' ' + @sort_direction + ' NULLS LAST' }.join(', ')
      query.order(sort_clause)
    end

    def set_sort_column
      @sort_column = params[:sort].presence || find_sort_config[:column]
    end

    def set_sort_direction
      @sort_direction = params[:direction].presence || find_sort_config[:direction].presence || 'asc'
    end

    def find_sort_config
      if params[:sort].present?
        sort_columns.detect { |item| item[:column] == params[:sort] }
      else
        default_column = sort_columns.detect { |item| item[:default] }
        default_column || sort_columns.first
      end
    end
end
