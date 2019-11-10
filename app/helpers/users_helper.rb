module UsersHelper
  def can_edit_resource?(resource) # TODO add pundit
    if resource.is_a?(User)
      resource.id == current_user&.id
    else
      resource.user_id == current_user&.id
    end
  end
end
