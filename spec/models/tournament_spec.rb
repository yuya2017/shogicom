require 'rails_helper'

RSpec.describe Tournament, type: :model do
  let(:user) { create(:user) }
  let(:tournament) { create(:tournament) }

  context "tournament_chess,tournament_app,tournament_time,tournament_limit,tournament_date,tournament_number_of_peopleが存在する場合" do
    it "有効な状態であること" do
      expect(tournament).to be_valid
    end
    context "tournament_number_of_peopleが存在しない場合"
    it "有効な状態であること" do
      expect(create(:tournament, tournament_number_of_people: nil)).to be_valid
    end
  end

  describe "空白のvalidate" do
    context "tournament_chessが存在しない場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_chess: nil)
        tournament.valid?
        expect(tournament.errors[:tournament_chess]).to include("を入力してください")
      end
    end
    context "tournament_appが存在しない場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_app: nil)
        tournament.valid?
        expect(tournament.errors[:tournament_app]).to include("を入力してください")
      end
    end
    context "tournament_timeが存在しない場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_time: nil)
        tournament.valid?
        expect(tournament.errors[:tournament_time]).to include("を入力してください")
      end
    end
    context "tournament_limitが存在しない場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_limit: nil)
        tournament.valid?
        expect(tournament.errors[:tournament_limit]).to include("を入力してください")
      end
    end
    context "tournament_at_dateが存在しない場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_at_date: nil)
        tournament.valid?
        expect(tournament.errors[:tournament_at_date]).to include("を入力してください")
      end
    end
    context "tournament_at_hourが存在しない場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_at_hour: nil)
        tournament.valid?
        expect(tournament.errors[:tournament_at_hour]).to include("を入力してください")
      end
    end
    context "tournament_at_minuteが存在しない場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_at_minute: nil)
        tournament.valid?
        expect(tournament.errors[:tournament_at_minute]).to include("を入力してください")
      end
    end
    context "user_idが存在しない場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, user_id: nil)
        tournament.valid?
        expect(tournament.errors[:user_id]).to include("を入力してください")
      end
    end
  end

  describe "文字数制限のvalidate" do
    context "tournament_chessが11文字以上の場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_chess: "12345678901")
        tournament.valid?
        expect(tournament.errors[:tournament_chess]).to include("は10文字以内で入力してください")
      end
    end
    context "tournament_appが21文字以上の場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_app: "123456789012345678901")
        tournament.valid?
        expect(tournament.errors[:tournament_app]).to include("は20文字以内で入力してください")
      end
    end
    context "tournament_appが16文字以上の場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_time: "1234567890123456")
        tournament.valid?
        expect(tournament.errors[:tournament_time]).to include("は15文字以内で入力してください")
      end
    end
    context "tournament_all_tagが51文字以上の場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_all_tag: "123456789012345678901234567890123456789012345678901")
        tournament.valid?
        expect(tournament.errors[:tournament_all_tag]).to include("は50文字以内で入力してください")
      end
    end
    context "tournament_contentが101文字以上の場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
        tournament.valid?
        expect(tournament.errors[:tournament_content]).to include("は100文字以内で入力してください")
      end
    end
    context "tournament_number_of_peopleが2人未満の場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, tournament_number_of_people: 1)
        tournament.valid?
        expect(tournament.errors[:tournament_number_of_people]).to include("は1より大きい値にしてください")
      end
    end
  end

  describe "期日のvalidate" do
    context "応募期間が今日より前の場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, :limit_before)
        tournament.valid?
        expect(tournament.errors[:tournament_limit]).to include("は今日以降にしてください。")
      end
      context "応募期間が今日の場合" do
        it "有効な状態あること" do
          expect(create(:tournament, :limit_today)).to be_valid
        end
      end
    end
    context "開催日時が応募期間よりも前の日場合" do
      it "無効な状態であること" do
        tournament = build(:tournament, :date_before)
        tournament.valid?
        expect(tournament.errors[:tournament_date]).to include("は応募期間より後にしてください")
      end
      context "開催日時と応募期日が同じ日時の場合" do
        it "有効な状態であること" do
          tournament = create(:tournament, :date_same_limit)
          expect(tournament).to be_valid
        end
      end
      context "開催日時と応募期日が同じ日時で応募期日が23:59分の場合" do
        it "有効な状態であること" do
          tournament = create(:tournament, :different_time)
          expect(tournament).to be_valid
        end
      end
    end
  end

  describe "set_dateメソッド" do
    it "tournament_dateが生成されること" do
      tournament = build(:tournament)
      tournament.set_date
      dt = Date.today >> 2
      expect(tournament.tournament_date).to eq Time.local(dt.year, dt.month, dt.day, 3, 30, 00, 0)
    end
  end

  describe "tournament_user_createメソッド" do
    it "TournamentUserが生成されること" do
      expect{ Tournament.tournament_user_create(tournament.user.id, tournament.id) }.to change{ TournamentUser.count }.by(1)
    end
  end

  describe  "enterTournamentメソッド" do
    context "応募人数を超えておらず、応募期日内の場合" do
      it "TournamentUserが生成されること" do
        Tournament.tournament_user_create(tournament.user.id, tournament.id)
        expect{ Tournament.enterTournament(user.id, tournament.id) }.to change{ TournamentUser.count }.by(1)
      end
    end
    context "応募人数を超えていた場合" do
      it "TournamentUserが生成されないこと" do
        tournament = create(:tournament, tournament_number_of_people: 2 )
        user3 = create(:user)
        Tournament.tournament_user_create(tournament.user.id, tournament.id)
        Tournament.enterTournament(user.id, tournament.id)
        expect{ Tournament.enterTournament(user3.id, tournament.id) }.to change{ TournamentUser.count }.by(0)
      end
    end
    context "応募期日を過ぎた場合" do
      it "TournamentUserが生成されないこと" do
        tournament = build(:tournament, :limit_over)
        tournament.save(validate: false)
        Tournament.tournament_user_create(tournament.user.id, tournament.id)
        expect{ Tournament.enterTournament(user.id, tournament.id) }.to change{ TournamentUser.count }.by(0)
      end
    end
    context "同じ大会に同じ人が参加してきた場合" do
      it "TournamentUserが生成されないこと" do
        Tournament.tournament_user_create(tournament.user.id, tournament.id)
        Tournament.enterTournament(user.id, tournament.id)
        expect{ Tournament.enterTournament(user.id, tournament.id) }.to change{ TournamentUser.count }.by(0)
      end
    end
  end
end
