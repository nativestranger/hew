class CallMailer < ApplicationMailer # :nodoc:
  def approved(call)
    mail(
      to:      call.user.email,
      subject: "Your call has been approved by Mox!",
      body:    call_url(call).to_s
    )
  end
end
