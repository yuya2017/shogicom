class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target_room, only: [:private_show, :post_show, :tournament_show, :community_show]
  before_action :private_room_confirmation, only: :private_show
  before_action :tournament_room_confirmation, only: :tournament_show
  before_action :community_room_confirmation, only: :community_show

  def private_show
    if @room.private_id.present?
      @messages = @room.messages.includes(:user)
      @message = current_user.messages.build
      session[:room_id] = @room.id
      rooms = Room.all
      @private_messages, @message_users, @no_messages, @no_message_users = Room.my_private_room(rooms, current_user)
    else
      redirect_to root_path, notice: "個人用チャットルームへはアクセスできません。"
    end
  end

  def post_show
    if @room.post_id.present?
      @messages = @room.messages.includes(:user)
      @message = current_user.messages.build
      session[:room_id] = @room.id
      messages = current_user.messages
      posts = current_user.posts.includes(:room)
      @post_messages, @no_message_posts = Room.my_post_room(messages, posts)
    else
      redirect_to root_path, notice: "オンライン対戦のチャットルームへはアクセスできません。"
    end
  end

  def tournament_show
    if @room.tournament_id.present?
      @messages = @room.messages.includes(:user)
      @message = current_user.messages.build
      session[:room_id] = @room.id
      tournament_users = current_user.tournament_users.all
      @tournament_messages, @tournament_no_messages = Room.my_tournament_room(tournament_users)
    else
      redirect_to root_path, notice: "大会のチャットルームへはアクセスできません。"
    end
  end

  def community_show
    if @room.community_id.present?
      @messages = @room.messages.includes(:user)
      @message = current_user.messages.build
      session[:room_id] = @room.id
      community_users = current_user.community_users.all
      @community_messages, @community_no_messages = Room.my_community_room(community_users)
    else
      redirect_to root_path, notice: "イベントのチャットルームへはアクセルできません。"
    end
  end


  #個人用チャット(2人しか入れないチャットルームを作成)
  def create_private_room
    if current_user.id == params[:user_id].to_i
      redirect_to root_path, notice: "自分だけの部屋は作成できません・"
    else
      room_key = Room.enterRoom(current_user.id, params[:user_id].to_i)
      redirect_to "/rooms/#{room_key}/private"
    end
  end

  def private_message
    rooms = Room.all
    @private_messages, @message_users, @no_messages, @no_message_users = Room.my_private_room(rooms, current_user)
  end

  def participating_post
    messages = current_user.messages
    posts = current_user.posts.includes(:room)
    @post_messages, @no_message_posts = Room.my_post_room(messages, posts)
  end

  def participating_tournament
    tournament_users = current_user.tournament_users.all
    @tournament_messages, @tournament_no_messages = Room.my_tournament_room(tournament_users)
  end

  def participating_community
    community_users = current_user.community_users.all
    @community_messages, @community_no_messages = Room.my_community_room(community_users)
  end

  private

  def set_target_room
    @room = Room.find(params[:id])
  end

  #個人用チャットルームへの制限
  def private_room_confirmation
    if @room.private_id.present?
      unless @room.user_id == current_user.id || @room.private_id == current_user.id
        redirect_to root_path, notice: "このチャットルームへは入れません。"
      end
    end
  end

  #大会制限
  def tournament_room_confirmation
    if @room.tournament_id.present?
      user = TournamentUser.where(tournament_id: @room.tournament.id).select(:user_id)
      user_key = []
      user.each do |i|
        user_key.push(i.user_id)
      end
      unless user_key.include?(current_user.id)
        redirect_to root_path, notice: "大会へ参加してください。"
      end
    end
  end

  #イベント制限
  def community_room_confirmation
    if @room.community_id.present?
      user = CommunityUser.where(community_id: @room.community.id).select(:user_id)
      user_key = []
      user.each do |i|
        user_key.push(i.user_id)
      end
      unless user_key.include?(current_user.id)
        redirect_to root_path, notice: "イベントへ参加してください。"
      end
    end
  end
end
