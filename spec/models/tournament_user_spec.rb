require 'rails_helper'

RSpec.describe TournamentUser, type: :model do
  let(:tournament) { create(:tournament) }
  
  context "userとtournamentが存在する場合" do
    it "有効な状態であること" do
      tournament_user = TournamentUser.new(
        tournament_id: tournament.id,
        user_id: tournament.user.id
      )
      expect(tournament_user).to be_valid
    end
  end
  context "user_idが存在しない場合" do
    it "無効な状態であること" do
      tournament_user = TournamentUser.new(user_id: nil)
      tournament_user.valid?
      expect(tournament_user.errors[:user_id]).to include("を入力してください")
    end
  end
  context "tournament_idが存在しない場合" do
    it "無効な状態であること" do
      tournament_user = TournamentUser.new(tournament_id: nil)
      tournament_user.valid?
      expect(tournament_user.errors[:tournament_id]).to include("を入力してください")
    end
  end
end
