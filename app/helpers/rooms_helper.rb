module RoomsHelper

  def user_search
    if @room.private_id == current_user.id
      User.find(@room.user_id).user_name
    else
      User.find(@room.private_id).user_name
    end
  end

end
