class ShowMailer < ApplicationMailer # :nodoc:
  def approved(show)
    mail(
      to:      show.user.email,
      subject: "Your show has been approved by Hew!",
      body:    show_url(show).to_s
    )
  end
end
