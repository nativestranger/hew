class ShowApplicationMailer < ApplicationMailer # :nodoc:
  def new_application(show_application)
    mail(
      to:      show_application.show.user.email,
      subject: "You have a new artist submission from #{show_application.user.full_name}",
      body:    show_applications_url(show_application.show).to_s
    )
  end

  def new_artist(show_application) # TODO: custom messaging here. (& account/PW setup)
    user = show_application.user
    user.send(:generate_confirmation_token)

    mail(
      to:      show_application.show.user.email,
      subject: "Thanks for applying to #{show_application.show.name}. Confirm your email address to get started.",
      body:    user_confirmation_url(confirmation_token: user.confirmation_token)
    )
  end
end
