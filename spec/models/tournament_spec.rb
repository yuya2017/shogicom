require 'rails_helper'

RSpec.describe Tournament, type: :model do
  describe "有効な状態であること" do
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
    end
    it "棋力、アプリ、持ち時間、応募期日、開催日時があれば有効な状態であること" do
      tournament = Tournament.new(
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
      expect(tournament).to be_valid
    end
  end

  describe "空白のvalidate" do
    it "棋力がなければ無効な状態であること" do
      tournament = Tournament.new(
        tournament_chess: nil,
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_chess]).to include("を入力してください")
    end
    it "アプリがなければ無効な状態であること" do
      tournament = Tournament.new(
        tournament_app: nil,
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_app]).to include("を入力してください")
    end
    it "持ち時間がなければ無効な状態であること" do
      tournament = Tournament.new(
        tournament_time: nil,
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_time]).to include("を入力してください")
    end
    it "応募期間がなければ無効な状態であること" do
      tournament = Tournament.new(
        tournament_limit: nil,
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_limit]).to include("を入力してください")
    end
    it "開催日時(日付)がなければ無効な状態であること" do
      tournament = Tournament.new(
        tournament_at_date: nil,
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_at_date]).to include("を入力してください")
    end
    it "開催日時(時間)がなければ無効な状態であること" do
      tournament = Tournament.new(
        tournament_at_hour: nil,
        tournament_at_date: "2022/02/22",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_at_hour]).to include("を入力してください")
    end
    it "開催日時(分)がなければ無効な状態であること" do
      tournament = Tournament.new(
        tournament_at_minute: nil,
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
      )
      tournament.valid?
      expect(tournament.errors[:tournament_at_minute]).to include("を入力してください")
    end
    it "開催日時(分)がなければ無効な状態であること" do
      tournament = Tournament.new(
        user_id: nil,
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
      )
      tournament.valid?
      expect(tournament.errors[:user_id]).to include("を入力してください")
    end
  end

  describe "文字数制限のvalidate" do
    it "棋力が11文字以上ある場合無効な状態であること" do
      tournament = Tournament.new(
        tournament_chess: "12345678901",
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_chess]).to include("は10文字以内で入力してください")
    end
    it "アプリ名が21文字以上ある場合無効な状態であること" do
      tournament = Tournament.new(
        tournament_app: "123456789012345678901",
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_app]).to include("は20文字以内で入力してください")
    end
    it "持ち時間が16文字以上ある場合無効な状態であること" do
      tournament = Tournament.new(
        tournament_time: "1234567890123456",
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_time]).to include("は15文字以内で入力してください")
    end
    it "タグが51文字以上ある場合無効な状態であること" do
      tournament = Tournament.new(
        tournament_all_tag: "123456789012345678901234567890123456789012345678901",
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_all_tag]).to include("は50文字以内で入力してください")
    end
    it "募集内容が101文字以上ある場合無効な状態であること" do
      tournament = Tournament.new(
        tournament_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901",
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_content]).to include("は100文字以内で入力してください")
    end
    it "応募人数は2人以上であるとき無効な状態であること" do
      tournament = Tournament.new(
        tournament_number_of_people: 1,
        tournament_at_date: "2022/02/22",
        tournament_at_hour: "12",
        tournament_at_minute: "30"
      )
      tournament.valid?
      expect(tournament.errors[:tournament_number_of_people]).to include("は1より大きい値にしてください")
    end
  end

  describe "期日のvalidate" do
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
    end
    context "応募期間は今日より後でないと無効な状態であること" do
      it "今日より前の場合無効な状態であること" do
        tournament = Tournament.new(
          tournament_limit: "2020/01/01".to_time,
          tournament_at_date: "2022/02/22",
          tournament_at_hour: "12",
          tournament_at_minute: "30"
        )
        tournament.valid?
        expect(tournament.errors[:tournament_limit]).to include("は今日以降にしてください。")
      end
      it "今日の場合は有効な状態あること" do
        tournament = Tournament.new(
          tournament_chess: "30級",
          tournament_app: "将棋",
          tournament_time: "10分",
          tournament_limit: Date.today,
          tournament_at_date: "2022/02/22",
          tournament_at_hour: "12",
          tournament_at_minute: "30",
          user: @user
        )
        expect(tournament).to be_valid
      end
    end
    context "開催日時は応募期間よりも前" do
      it "開催日時が応募期間よりも前の場合無効な状態であること" do
        tournament = Tournament.new(
          tournament_limit: "2022/02/23".to_time,
          tournament_at_date: "2022/02/20",
          tournament_at_hour: "12",
          tournament_at_minute: "30"
        )
        tournament.valid?
        expect(tournament.errors[:tournament_date]).to include("は応募期間より後にしてください")
      end
      it "開催日時と応募期日が同じ日時の場合は有効な状態であること" do
        tournament = Tournament.new(
          tournament_chess: "30級",
          tournament_app: "将棋",
          tournament_time: "10分",
          tournament_limit: "2022/02/22".to_time,
          tournament_at_date: "2022/02/22",
          tournament_at_hour: "00",
          tournament_at_minute: "00",
          user: @user
        )
        tournament.valid?
        expect(tournament).to be_valid
      end
    end
  end

  describe "メソッド" do
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
    end
    it "set_dateメソッド" do
      tournament = Tournament.new(
        tournament_chess: "30級",
        tournament_app: "将棋",
        tournament_time: "10分",
        tournament_limit: "2022/02/22".to_time,
        tournament_at_date: "2022/02/25",
        tournament_at_hour: "12",
        tournament_at_minute: "30",
        user: @user
      )
      tournament.valid?
      expect(tournament.tournament_date).to eq Time.local(2022, 02, 25, 12, 30, 00, 0)
    end
    it "tournament_user_createメソッド" do
      tournament = Tournament.create(
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
      expect{ Tournament.tournament_user_create(@user.id, tournament.id) }.to change{ TournamentUser.count }.by (1)
    end
    context "enterTournamentメソッドでTournamentUserが増えること" do
      before do
        @user2 = User.create(
          user_name: "鈴木太郎",
          email: "tester2@example.com",
          user_chess: "30級",
          user_app: "将棋",
          user_time: "10分",
          user_pref: 13,
          password: "password",
          confirmed_at: Time.now
        )
      end
      it "応募人数を超えておらず、応募期日内" do
        tournament = Tournament.create(
          tournament_chess: "30級",
          tournament_app: "将棋",
          tournament_time: "10分",
          tournament_time: "10分",
          tournament_limit: Date.today,
          tournament_at_date: "2022/02/25",
          tournament_at_hour: "12",
          tournament_at_minute: "30",
          tournament_number_of_people: 2,
          user: @user
        )
        Tournament.tournament_user_create(@user.id, tournament.id)
        expect{ Tournament.enterTournament(@user2.id, tournament.id) }.to change{ TournamentUser.count }.by(1)
      end
    end
    context "enterTournamentメソッドでTournamentUserが増えないこと" do
      before do
        @user2 = User.create(
          user_name: "鈴木太郎",
          email: "tester2@example.com",
          user_chess: "30級",
          user_app: "将棋",
          user_time: "10分",
          user_pref: 13,
          password: "password",
          confirmed_at: Time.now
        )
      end
      it "応募人数を超えていた場合" do
        @user3 = User.create(
          user_name: "鈴木次郎",
          email: "tester3@example.com",
          user_chess: "30級",
          user_app: "将棋",
          user_time: "10分",
          user_pref: 13,
          password: "password",
          confirmed_at: Time.now
        )
        tournament = Tournament.create(
          tournament_chess: "30級",
          tournament_app: "将棋",
          tournament_time: "10分",
          tournament_time: "10分",
          tournament_limit: "2022/02/22".to_time,
          tournament_at_date: "2022/02/25",
          tournament_at_hour: "12",
          tournament_at_minute: "30",
          tournament_number_of_people: 2,
          user: @user
        )
        Tournament.tournament_user_create(@user.id, tournament.id)
        Tournament.enterTournament(@user2.id, tournament.id)
        expect{ Tournament.enterTournament(@user3.id, tournament.id) }.to change{ TournamentUser.count }.by(0)
      end
      it "応募期日を過ぎた場合" do
        tournament = Tournament.new(
          tournament_chess: "30級",
          tournament_app: "将棋",
          tournament_time: "10分",
          tournament_time: "10分",
          tournament_limit: "2020/02/22".to_time,
          tournament_date: "2022/02/25".to_time,
          user: @user
        )
        tournament.save(validate: false)
        Tournament.tournament_user_create(@user.id, tournament.id)
        expect{ Tournament.enterTournament(@user2.id, tournament.id) }.to change{ TournamentUser.count }.by(0)
      end
      it "同じ大会に同じ人が参加してきた場合" do
        tournament = Tournament.create(
          tournament_chess: "30級",
          tournament_app: "将棋",
          tournament_time: "10分",
          tournament_time: "10分",
          tournament_limit: "2022/02/22".to_time,
          tournament_at_date: "2022/02/25",
          tournament_at_hour: "12",
          tournament_at_minute: "30",
          tournament_number_of_people: 3,
          user: @user
        )
        Tournament.tournament_user_create(@user.id, tournament.id)
        Tournament.enterTournament(@user2.id, tournament.id)
        expect{ Tournament.enterTournament(@user2.id, tournament.id) }.to change{ TournamentUser.count }.by(0)
      end
    end
  end
end
