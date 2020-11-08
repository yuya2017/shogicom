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
    TournamentUser.create(
      user_id: user_id,
      tournament_id: tournament_id
    )
  end

  def self.enterTournament(user_id, tournament_id)
    tournament = Tournament.find(tournament_id)
    tournament_users = tournament.tournament_users.all
    if tournament.tournament_limit >= Date.today && tournament.tournament_number_of_people > tournament_users.count && tournament_users.find_by(user_id: user_id).blank?
      TournamentUser.create(
        user_id: user_id,
        tournament_id: tournament_id
      )
      return tournament
    else
      return nil
    end
  end

end
