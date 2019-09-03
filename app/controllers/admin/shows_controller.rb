module Admin
  class ShowsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Show.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Show.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def update
      was_approved = requested_resource.is_approved?
      super
      if !was_approved && requested_resource.is_approved?
        ShowMailer.approved(requested_resource).deliver_later
      end
    end
  end
end
