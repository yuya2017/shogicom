class Room < ApplicationRecord

  belongs_to :user, optional: true
  belongs_to :post, optional: true
  belongs_to :tournament, optional: true
  belongs_to :community, optional: true
  has_many :messages, dependent: :destroy


  validates :room_name, presence: true, length: { maximum: 10 }

  def self.enterRoom(user_id, private_id)
    if Room.where(user_id: user_id).where(private_id: private_id).present?
      Room.where(user_id: user_id).where(private_id: private_id)[0].id
    elsif Room.where(private_id: user_id).where(user_id: private_id).present?
      Room.where(private_id: user_id).where(user_id: private_id)[0].id
    else
      room = Room.create(
        room_name: "個人用チャットルーム",
        user_id: user_id,
        private_id: private_id
      )
      room.id
    end
  end

  def self.my_private_room(rooms, current_user)
    private_messages = []
    message_users = []
    no_messages = []
    no_message_users = []
    rooms.each do |room|
      if (room.private_id.present?) && (current_user.id == room.user_id || current_user.id == room.private_id)
        if  Message.where(room_id: room.id).present?
            private_messages.push(Message.where(room_id: room.id).last(1)[0])
        else
          no_messages.unshift(room)
          if room.user_id == current_user.id
            no_message_users.unshift(User.find(room.private_id))
          else
            no_message_users.unshift(User.find(room.user_id))
          end
        end
      end
    end
    private_messages = private_messages.sort.reverse
    private_messages.each do |message|
      if Room.find(message.room_id).user_id == current_user.id
        message_users.push(User.find(Room.find(message.room_id).private_id))
      else
        message_users.push(User.find(Room.find(message.room_id).user_id))
      end
    end
    return private_messages, message_users, no_messages, no_message_users
  end

  def self.my_post_room(messages, posts)
    post_rooms = []
    post_messages = []
    no_message_posts = []
    messages.each do |message|
      next if message.id == nil
      unless post_rooms.include?(Room.find(message.room_id))
        post_rooms.push(Room.find(message.room_id))
      end
    end
    posts.each do |post|
      unless post_rooms.include?(Room.find(post.room.id))
        if Message.where(room_id: post.room.id).present?
          post_rooms.push(Room.find(post.room.id))
        else
          no_message_posts.unshift(post)
        end
      end
    end
    post_rooms.each do |room|
      if room.post_id.present?
        post_messages.push(Message.where(room_id: room.id).last(1)[0])
      end
    end
    post_messages = post_messages.sort.reverse
    return post_messages, no_message_posts
  end

  def self.my_tournament_room(tournament_users)
    tournament_rooms = []
    tournament_messages = []
    tournament_no_messages = []
    tournament_users.each do |tournament|
      tournament_rooms.push(Tournament.find(tournament.tournament_id).room)
    end
    tournament_rooms.each do |room|
      if Message.where(room_id: room.id).present?
        tournament_messages.push(Message.where(room_id: room.id).last(1)[0])
      else
        tournament_no_messages.unshift(Tournament.find(room.tournament_id))
      end
    end
    tournament_messages = tournament_messages.sort.reverse
    return tournament_messages, tournament_no_messages
  end

  def self.my_community_room(community_users)
    community_rooms = []
    community_messages = []
    community_no_messages = []
    community_users.each do |community|
      community_rooms.push(Community.find(community.community_id).room)
    end
    community_rooms.each do |room|
      if Message.where(room_id: room.id).present?
        community_messages.push(Message.where(room_id: room.id).last(1)[0])
      else
        community_no_messages.unshift(Community.find(room.community_id))
      end
    end
    community_messages = community_messages.sort.reverse
    return community_messages, community_no_messages
  end

end
