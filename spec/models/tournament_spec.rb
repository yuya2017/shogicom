require 'rails_helper'

RSpec.describe Tournament, type: :model do
  describe "有効な状態であること" do
    it "棋力、アプリ、持ち時間、応募期日、開催日時があれば有効な状態であること" do
      expect(create(:tournament)).to be_valid
    end
    it "応募人数はなくても有効な状態であること" do
      expect(create(:tournament, tournament_number_of_people: nil)).to be_valid
    end
  end

  describe "空白のvalidate" do
    it "棋力がなければ無効な状態であること" do
      tournament = build(:tournament, tournament_chess: nil)
      tournament.valid?
      expect(tournament.errors[:tournament_chess]).to include("を入力してください")
    end
    it "アプリがなければ無効な状態であること" do
      tournament = build(:tournament, tournament_app: nil)
      tournament.valid?
      expect(tournament.errors[:tournament_app]).to include("を入力してください")
    end
    it "持ち時間がなければ無効な状態であること" do
      tournament = build(:tournament, tournament_time: nil)
      tournament.valid?
      expect(tournament.errors[:tournament_time]).to include("を入力してください")
    end
    it "応募期間がなければ無効な状態であること" do
      tournament = build(:tournament, tournament_limit: nil)
      tournament.valid?
      expect(tournament.errors[:tournament_limit]).to include("を入力してください")
    end
    it "開催日時(日付)がなければ無効な状態であること" do
      tournament = build(:tournament, tournament_at_date: nil)
      tournament.valid?
      expect(tournament.errors[:tournament_at_date]).to include("を入力してください")
    end
    it "開催日時(時間)がなければ無効な状態であること" do
      tournament = build(:tournament, tournament_at_hour: nil)
      tournament.valid?
      expect(tournament.errors[:tournament_at_hour]).to include("を入力してください")
    end
    it "開催日時(分)がなければ無効な状態であること" do
      tournament = build(:tournament, tournament_at_minute: nil)
      tournament.valid?
      expect(tournament.errors[:tournament_at_minute]).to include("を入力してください")
    end
    it "ユーザーがなければ無効な状態であること" do
      tournament = build(:tournament, user_id: nil)
      tournament.valid?
      expect(tournament.errors[:user_id]).to include("を入力してください")
    end
  end

  describe "文字数制限のvalidate" do
    it "棋力が11文字以上ある場合無効な状態であること" do
      tournament = build(:tournament, tournament_chess: "12345678901")
      tournament.valid?
      expect(tournament.errors[:tournament_chess]).to include("は10文字以内で入力してください")
    end
    it "アプリ名が21文字以上ある場合無効な状態であること" do
      tournament = build(:tournament, tournament_app: "123456789012345678901")
      tournament.valid?
      expect(tournament.errors[:tournament_app]).to include("は20文字以内で入力してください")
    end
    it "持ち時間が16文字以上ある場合無効な状態であること" do
      tournament = build(:tournament, tournament_time: "1234567890123456")
      tournament.valid?
      expect(tournament.errors[:tournament_time]).to include("は15文字以内で入力してください")
    end
    it "タグが51文字以上ある場合無効な状態であること" do
      tournament = build(:tournament, tournament_all_tag: "123456789012345678901234567890123456789012345678901")
      tournament.valid?
      expect(tournament.errors[:tournament_all_tag]).to include("は50文字以内で入力してください")
    end
    it "募集内容が101文字以上ある場合無効な状態であること" do
      tournament = build(:tournament, tournament_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
      tournament.valid?
      expect(tournament.errors[:tournament_content]).to include("は100文字以内で入力してください")
    end
    it "応募人数は2人以上であるとき無効な状態であること" do
      tournament = build(:tournament, tournament_number_of_people: 1)
      tournament.valid?
      expect(tournament.errors[:tournament_number_of_people]).to include("は1より大きい値にしてください")
    end
  end

  describe "期日のvalidate" do
    context "応募期間は今日より後でないと無効な状態であること" do
      it "今日より前の場合無効な状態であること" do
        tournament = build(:tournament, :limit_before)
        tournament.valid?
        expect(tournament.errors[:tournament_limit]).to include("は今日以降にしてください。")
      end
      it "今日の場合は有効な状態あること" do
        expect(create(:tournament, :limit_today)).to be_valid
      end
    end
    context "開催日時は応募期間よりも前" do
      it "開催日時が応募期間よりも前の場合無効な状態であること" do
        tournament = build(:tournament, :date_before)
        tournament.valid?
        expect(tournament.errors[:tournament_date]).to include("は応募期間より後にしてください")
      end
      it "開催日時と応募期日が同じ日時の場合は有効な状態であること" do
        tournament = create(:tournament, :date_same_limit)
        expect(tournament).to be_valid
      end
      it "開催日時と応募期日が同じ日時で応募期日が23:59分まで有効な状態であること" do
        tournament = create(:tournament, :different_time)
        expect(tournament).to be_valid
      end
    end
  end

  describe "メソッド" do
    it "set_dateメソッド" do
      tournament = build(:tournament)
      tournament.set_date
      expect(tournament.tournament_date).to eq Time.local(2022, 02, 25, 12, 30, 00, 0)
    end
    it "tournament_user_createメソッド" do
      tournament = create(:tournament)
      expect{ Tournament.tournament_user_create(tournament.user.id, tournament.id) }.to change{ TournamentUser.count }.by (1)
    end
    describe "大会への参加" do
      before do
        @user = create(:user)
      end
      context "enterTournamentメソッドでTournamentUserが増えること" do
        it "応募人数を超えておらず、応募期日内" do
          tournament = create(:tournament)
          Tournament.tournament_user_create(tournament.user.id, tournament.id)
          expect{ Tournament.enterTournament(@user.id, tournament.id) }.to change{ TournamentUser.count }.by(1)
        end
      end
      context "enterTournamentメソッドでTournamentUserが増えないこと" do
        it "応募人数を超えていた場合" do
          tournament = create(:tournament, tournament_number_of_people: 2 )
          user3 = create(:user)
          Tournament.tournament_user_create(tournament.user.id, tournament.id)
          Tournament.enterTournament(@user.id, tournament.id)
          expect{ Tournament.enterTournament(user3.id, tournament.id) }.to change{ TournamentUser.count }.by(0)
        end
        it "応募期日を過ぎた場合" do
          tournament = build(:tournament, :limit_over)
          tournament.save(validate: false)
          Tournament.tournament_user_create(tournament.user.id, tournament.id)
          expect{ Tournament.enterTournament(@user.id, tournament.id) }.to change{ TournamentUser.count }.by(0)
        end
        it "同じ大会に同じ人が参加してきた場合" do
          tournament = create(:tournament)
          Tournament.tournament_user_create(tournament.user.id, tournament.id)
          Tournament.enterTournament(@user.id, tournament.id)
          expect{ Tournament.enterTournament(@user.id, tournament.id) }.to change{ TournamentUser.count }.by(0)
        end
      end
    end
  end
end
