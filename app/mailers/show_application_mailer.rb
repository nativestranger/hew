class ShowApplicationMailer < ApplicationMailer # :nodoc:
  def new_application(show_application)
    mail(
      to:      show_application.show.user.email,
      subject: "You have a new artist submission from #{show_application.user.full_name}",
      body:    show_applications_url(show_application.show).to_s
    )
  end
end
