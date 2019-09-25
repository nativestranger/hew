class CallApplicationMailer < ApplicationMailer # :nodoc:
  def new_application(call_application)
    mail(
      to:      call_application.call.user.email,
      subject: "You have a new artist submission from #{call_application.user.full_name}",
      body:    call_applications_url(call_application.call).to_s
    )
  end

  def new_artist(call_application) # TODO: custom messaging here. (& account/PW setup)
    user = call_application.user
    user.send(:generate_confirmation_token)

    mail(
      to:      call_application.call.user.email,
      subject: "Thanks for applying to #{call_application.call.name}. Confirm your email address to get started.",
      body:    user_confirmation_url(confirmation_token: user.confirmation_token)
    )
  end
end
