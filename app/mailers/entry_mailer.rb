class EntryMailer < ApplicationMailer # :nodoc:
  def new_application(entry)
    mail(
      to:      entry.call.user.email,
      subject: "You have a new artist submission from #{entry.user.full_name}",
      body:    entries_url(entry.call).to_s
    )
  end

  def new_artist(entry) # TODO: custom messaging here. (& account/PW setup)
    user = entry.user
    user.send(:generate_confirmation_token)

    mail(
      to:      entry.user.email,
      subject: "Thanks for applying to #{entry.call.name}. Confirm your email address with this magic link.",
      body:    user_confirmation_url(confirmation_token: user.confirmation_token)
    )
  end
end
