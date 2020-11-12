require 'rails_helper'

RSpec.describe TournamentUser, type: :model do
  before do
    @user = User.create(
      user_name: "木下侑哉",
      email: "tester@example.com",
      user_chess: "30級",
      user_app: "将棋",
      user_time: "10分",
      user_pref: 13,
      password: "password",
      confirmed_at: Time.now
    )
    @tournament = Tournament.create(
      tournament_chess: "30級",
      tournament_app: "将棋",
      tournament_time: "10分",
      tournament_time: "10分",
      tournament_limit: "2022/02/22".to_time,
      tournament_at_date: "2022/02/25",
      tournament_at_hour: "12",
      tournament_at_minute: "30",
      user: @user
    )
  end
  describe "有効な状態であること" do
    it "userとtournamentがあれば有効な状態であること" do
      tournament_user = TournamentUser.new(
        tournament_id: @tournament.id,
        user_id: @user.id
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
