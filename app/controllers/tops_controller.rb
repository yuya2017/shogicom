class TopsController < ApplicationController
  before_action :authenticate_user!, only: [:mypage, :message, :participating_tournament, :participating_post, :private_message]

  def index
    @posts = Post.all.includes(:room).order(updated_at: "DESC").limit(10)
    @tournaments = Tournament.all.includes(:room).order(updated_at: "DESC").limit(10)
    @communities = Community.all.includes(:room).order(updated_at: "DESC").limit(10)
  end

  def mypage
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @tournaments = @user.tournaments.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @communities = @user.communities.page(params[:page]).includes(:room).order(updated_at: "DESC").limit(10)
  end

  def private_message
    rooms = Room.all
    @messages = []
    @message_users = []
    @no_messages = []
    @no_message_users = []
    rooms.each do |room|
      if (room.private_id.present?) && (current_user.id == room.user_id || current_user.id == room.private_id)
        if  Message.where(room_id: room.id).present?
            @messages.push(Message.where(room_id: room.id).last(1)[0])
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
    @messages = @messages.sort.reverse
    @messages.each do |message|
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
end
