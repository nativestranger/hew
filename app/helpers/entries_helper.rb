module EntriesHelper
  def call_application_progress_bar
    content_tag(:section, class: "content") do
      content_tag(:div, class: "navigator") do
        content_tag(:ol, class: 'wicked-progress') do
          wizard_steps.collect do |every_step|
            class_str = "unfinished"
            class_str = "current font-weight-bold"  if every_step == step || every_step == :start && @call_application.new_record?
            class_str = "finished" if past_step?(every_step)

            li_tag = content_tag(:li, class: class_str) do
              path = if @call_application.future_creation_status?(every_step) || @call_application.creation_status_submitted?
                '#'
              else
                wizard_path(every_step, call_application_id: @call_application.id)
              end
              link_to I18n.t(every_step), path
            end

            divider = nil
            unless every_step == :submitted # last
              divider = "<div class='divider #{ 'incomplete' unless past_step?(every_step) }'></div>"
            end

            str = <<-TIME
            #{ li_tag }
            #{ divider }
            TIME

            concat(str.html_safe)
          end
        end
      end
    end
  end

  def entry_search_category_options
    @search_categories.map { |k| [k.name, k.id] }
  end
end
