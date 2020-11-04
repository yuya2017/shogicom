class Tournament < ApplicationRecord

  belongs_to :user
  has_many :tournament_users, dependent: :destroy
  has_one :room, dependent: :destroy
  accepts_nested_attributes_for :room

  attr_writer :tournament_at_date, :tournament_at_hour, :tournament_at_minute

  before_validation :set_date
  validates :tournament_chess, presence: true, length: { maximum: 10 }
  validates :tournament_app, presence: true, length: { maximum: 20 }
  validates :tournament_time, presence: true, length: { maximum: 15 }
  validates :tournament_limit, presence: true
  validates :tournament_date, presence: true
  validates :user_id, presence: true
  validates :tournament_all_tag, length: { maximum: 30 }
  validates :tournament_content, length: { maximum: 100 }
  validates :tournament_at_date, presence: true
  validates :tournament_at_hour, presence: true
  validates :tournament_at_minute, presence: true


  def tournament_at_date
    @tournament_at_date
  end

  def tournament_at_hour
    @tournament_at_hour
  end
  def tournament_at_minute
    @tournament_at_minute
  end

  def set_date
    self.tournament_date = Time.zone.parse("#{@tournament_at_date} #{@tournament_at_hour}:#{@tournament_at_minute}:00")
  end

  def self.tournament_user_create(user_id, tournament_id)
    user = TournamentUser.new(
      user_id: user_id,
      tournament_id: tournament_id
    )
    user.save
  end

  def self.enterTournament(user_id, tournament_id)
    room = Room.find_by(tournament_id: tournament_id)
    user_key = []
    users = TournamentUser.where(tournament_id: tournament_id)
    users.each do |user|
      user_key.push(user.user_id)
    end
    if user_key.include?(user_id)
      return room
    else
      tournament_key = TournamentUser.new(
        user_id: user_id,
        tournament_id: tournament_id
      )
      tournament_key.save
      return room
    end
  end

end
