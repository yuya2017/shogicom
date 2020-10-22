class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target_room, only: [:show]
  before_action :private_room_confirmation, only: [:show]
  before_action :tournament_room_confirmation, only: [:show]

  def show
    @messages = @room.messages
    @message = current_user.messages.build
    session[:room_id] = @room.id
  end

  #個人用チャット(2人しか入れないチャットルームを作成)
  def create_private_room
    room_key = Room.enterRoom(current_user.id, params[:user_id].to_i)
    if room_key.class == Integer
      redirect_to("/rooms/#{room_key}")
    else
      if room_key.save!
        redirect_to("/rooms/#{room_key.id}")
      else
        redirect_to("/")
      end
    end
  end


  private

  def set_target_room
    @room = Room.find(params[:id])
  end

  #個人用チャットルームへの制限
  def private_room_confirmation
    if @room.private_id.present?
      unless @room.user_id == current_user.id || @room.private_id == current_user.id
        flash[:notice] = "このチャットルームへは入れません。"
        redirect_to("/")
      end
    end
  end

  #大会へ申し込んでいないとルームへは入れないようにする
  def tournament_room_confirmation
    if @room.tournament_id.present?
      user = TournamentUser.where(tournament_id: @room.tournament.id).select(:user_id)
      user_key = []
      user.each do |i|
        user_key.push(i.user_id)
      end
      unless user_key.include?(current_user.id)
        flash[:notice] = "大会へ参加してください。"
        redirect_to("/")
      end
    end
  end
end
