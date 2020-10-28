class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target_room, only: [:show]
  before_action :private_room_confirmation, only: [:show]
  before_action :tournament_room_confirmation, only: [:show]

  def show
    @messages = @room.messages
    @message = current_user.messages.build
    session[:room_id] = @room.id

    rooms = Room.all
    @private_messages = []
    @message_users = []
    @no_messages = []
    @no_message_users = []
    rooms.each do |room|
      if (room.private_id.present?) && (current_user.id == room.user_id || current_user.id == room.private_id)
        if  Message.where(room_id: room.id).present?
            @private_messages.push(Message.where(room_id: room.id).last(1)[0])
        else
          @no_messages.unshift(room)
          if room.user_id == current_user.id
            @no_message_users.unshift(User.find(room.private_id))
          else
            @no_message_users.unshift(User.find(room.user_id))
          end
        end
      end
    end
    @private_messages = @private_messages.sort.reverse
    @private_messages.each do |message|
      if Room.find(message.room_id).user_id == current_user.id
        @message_users.push(User.find(Room.find(message.room_id).private_id))
      else
        @message_users.push(User.find(Room.find(message.room_id).user_id))
      end
    end

    messages = current_user.messages
    private_rooms = []
    @post_messages = []

    messages.each do |message|
      next if message.id == nil
      unless private_rooms.include?(Room.find(message.room_id))
        private_rooms.push(Room.find(message.room_id))
      end
    end

    private_rooms.each do |room|
      if room.post_id.present?
        @post_messages.push(Message.where(room_id: room.id).last(1)[0])
      # if @post_messages.include?(oom.where(room_id: room.id).last(1)[0])
      #   @post_messages.push(Message.where(room_id: room.id).last(1)[0])
      end
    end
    @post_messages = @post_messages.sort.reverse



    tournament_user = current_user.tournament_users.all
    tournament_room = []
    @tournament_messages = []
    @tournament_no_messages = []
    tournament_user.each do |tournament|
      tournament_room.push(Tournament.find(tournament.tournament_id).room)
    end

    tournament_room.each do |room|
      if Message.where(room_id: room.id).present?
        @tournament_messages.push(Message.where(room_id: room.id).last(1)[0])
      else
        @tournament_no_messages.unshift(Tournament.find(room.tournament_id))
      end
    end

    @tournament_messages = @tournament_messages.sort.reverse


    community_user = current_user.community_users.all
    community_room = []
    @community_messages = []
    @community_no_messages = []
    community_user.each do |community|
      community_room.push(Community.find(community.community_id).room)
    end

    community_room.each do |room|
      if Message.where(room_id: room.id).present?
        @community_messages.push(Message.where(room_id: room.id).last(1)[0])
      else
        @community_no_messages.unshift(Community.find(room.community_id))
      end
    end

    @community_no_messages = @community_no_messages.sort.reverse
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

  def private_message
    rooms = Room.all
    @private_messages = []
    @message_users = []
    @no_messages = []
    @no_message_users = []
    rooms.each do |room|
      if (room.private_id.present?) && (current_user.id == room.user_id || current_user.id == room.private_id)
        if  Message.where(room_id: room.id).present?
            @private_messages.push(Message.where(room_id: room.id).last(1)[0])
        else
          @no_messages.unshift(room)
          if room.user_id == current_user.id
            @no_message_users.unshift(User.find(room.private_id))
          else
            @no_message_users.unshift(User.find(room.user_id))
          end
        end
      end
    end
    @private_messages = @private_messages.sort.reverse
    @private_messages.each do |message|
      if Room.find(message.room_id).user_id == current_user.id
        @message_users.push(User.find(Room.find(message.room_id).private_id))
      else
        @message_users.push(User.find(Room.find(message.room_id).user_id))
      end
    end


  end

  def participating_post
    messages = current_user.messages
    private_rooms = []
    @post_messages = []
    messages.each do |message|
      unless private_rooms.include?(Room.find(message.room_id))
      private_rooms.push(Room.find(message.room_id))
      end
    end

    private_rooms.each do |room|
      if room.post_id.present?
        @post_messages.push(Message.where(room_id: room.id).last(1)[0])
      # if @post_messages.include?(oom.where(room_id: room.id).last(1)[0])
      #   @post_messages.push(Message.where(room_id: room.id).last(1)[0])
      end
    end
    @post_messages = @post_messages.sort.reverse
  end

  def participating_tournament
    tournament_user = current_user.tournament_users.all
    tournament_room = []
    @tournament_messages = []
    @tournament_no_messages = []
    tournament_user.each do |tournament|
      tournament_room.push(Tournament.find(tournament.tournament_id).room)
    end

    tournament_room.each do |room|
      if Message.where(room_id: room.id).present?
        @tournament_messages.push(Message.where(room_id: room.id).last(1)[0])
      else
        @tournament_no_messages.unshift(Tournament.find(room.tournament_id))
      end
    end

    @tournament_messages = @tournament_messages.sort.reverse
  end

  def participating_community
    community_user = current_user.community_users.all
    community_room = []
    @community_messages = []
    @community_no_messages = []
    community_user.each do |community|
      community_room.push(Community.find(community.community_id).room)
    end

    community_room.each do |room|
      if Message.where(room_id: room.id).present?
        @community_messages.push(Message.where(room_id: room.id).last(1)[0])
      else
        @community_no_messages.unshift(Community.find(room.community_id))
      end
    end

    @community_no_messages = @community_no_messages.sort.reverse
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
