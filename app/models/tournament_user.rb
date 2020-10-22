class TournamentUser < ApplicationRecord

  belongs_to :user
  belongs_to :tournament

  validates :user_id, presence: true
  validates :tournament_id, presence: true
end
