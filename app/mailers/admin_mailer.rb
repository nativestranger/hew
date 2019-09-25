class AdminMailer < ApplicationMailer # :nodoc:
  def new_call(call)
    mail(
      to:      User.admins.pluck(:email),
      subject: "A newly-public call is ready for admin review",
      body:    admin_call_url(call.id).to_s
    )
  end
end
