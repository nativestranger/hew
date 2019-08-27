class AdminMailer < ApplicationMailer # :nodoc:
  def new_show(show)
    mail(
      to:      User.admins.pluck(:email),
      subject: "A newly-public show is ready for admin review",
      body:    admin_show_url(show.id).to_s
    )
  end
end
