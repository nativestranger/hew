class CallUserMailer < ApplicationMailer # :nodoc:
  def new_user(call_user) # TODO: custom messaging here. (& account/PW setup)
    user = call_user.user
    user.send(:generate_confirmation_token)

    acts_as = "a#{'n' if call_user.role_admin? } #{call_user.role}"

    mail(
      to:      call_user.user.email,
      subject: "You're invited to act as #{acts_as} on Mox. Congrats! Confirm your email address to get started.",
      body:    user_confirmation_url(confirmation_token: user.confirmation_token)
    )
  end
end
