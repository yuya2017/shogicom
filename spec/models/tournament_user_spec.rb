require 'rails_helper'

RSpec.describe TournamentUser, type: :model do
  before do
    @tournament = create(:tournament)
  end
  describe "有効な状態であること" do
    it "userとtournamentがあれば有効な状態であること" do
      tournament_user = TournamentUser.new(
        tournament_id: @tournament.id,
        user_id: @tournament.user.id
      )
      expect(tournament_user).to be_valid
    end
  end
  describe "無効な状態であること" do
    it "userがなければ無効な状態であること" do
      tournament_user = TournamentUser.new(user_id: nil)
      tournament_user.valid?
      expect(tournament_user.errors[:user_id]).to include("を入力してください")
    end
    it "tournamentがなければ無効な状態であること" do
      tournament_user = TournamentUser.new(tournament_id: nil)
      tournament_user.valid?
      expect(tournament_user.errors[:tournament_id]).to include("を入力してください")
    end
  end
end
