module CallApplicationsHelper
  def call_application_progress_bar
    content_tag(:section, class: "content") do
      content_tag(:div, class: "navigator") do
        content_tag(:ol, class: 'wicked-progress') do
          wizard_steps.collect do |every_step|
            class_str = "unfinished"
            class_str = "current font-weight-bold"  if every_step == step || every_step == :start && @call_application.new_record?
            class_str = "finished" if past_step?(every_step)

            li_tag = content_tag(:li, class: class_str) do
              link_to I18n.t(every_step), wizard_path(every_step, call_application_id: @call_application.id)
            end

            divider = nil
            unless every_step == :submit # last
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
end