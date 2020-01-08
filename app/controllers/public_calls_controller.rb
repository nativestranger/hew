class PublicCallsController < ApplicationController
  before_action :set_call
  before_action :ensure_public!

  def details
    if @call.external?
      @call.increment!(:view_count)
      redirect_to @call.external_url
    else
      @call_application = @call.application_for(current_user)
    end
  end

  private

  def ensure_public!
    redirect_to root_path unless @call.is_public?
  end

  def set_call
    @call = Call.find(params[:id])
  end
end
