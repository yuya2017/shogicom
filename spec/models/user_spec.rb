require 'rails_helper'

RSpec.describe User, type: :model do
  context "user_name,email,user_chess、user_app、user_time、user_pref、password,confirmed_atが存在する場合" do
    it "有効な状態であること" do
      expect(build(:user)).to be_valid
    end
  end

  describe "空白のvalidate" do
    context "user_nameが存在していない場合" do
      it "無効な状態であること" do
        user = build(:user, user_name: nil)
        user.valid?
        expect(user.errors[:user_name]).to include("を入力してください")
      end
    end
    context "emailが存在していない場合" do
      it "無効な状態であること" do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include("を入力してください")
      end
    end
    context "user_chessが存在していない場合" do
      it "無効な状態であること" do
        user = build(:user, user_chess: nil)
        user.valid?
        expect(user.errors[:user_chess]).to include("を入力してください")
      end
    end
    context "user_appが存在していない場合" do
      it "無効な状態であること" do
        user = build(:user, user_app: nil)
        user.valid?
        expect(user.errors[:user_app]).to include("を入力してください")
      end
    end
    context "user_timeが存在していない場合" do
      it "無効な状態であること" do
        user = build(:user, user_time: nil)
        user.valid?
        expect(user.errors[:user_time]).to include("を入力してください")
      end
    end
    context "user_prefが存在していない場合" do
      it "無効な状態であること" do
        user = build(:user, user_pref: nil)
        user.valid?
        expect(user.errors[:user_pref]).to include("を入力してください")
      end
    end
    context "passwordが存在していない場合" do
      it "無効な状態であること" do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include("を入力してください")
      end
    end
  end

  describe "文字数制限のvalidate" do
    context "user_nameが11文字以上の場合" do
      it "無効であること" do
        user = build(:user, user_name: "12345678901")
        user.valid?
        expect(user.errors[:user_name]).to include("は10文字以内で入力してください")
      end
    end
    context "user_chessが11文字以上の場合" do
      it "無効であること" do
        user = build(:user, user_chess: "12345678901")
        user.valid?
        expect(user.errors[:user_chess]).to include("は10文字以内で入力してください")
      end
    end
    context "user_appが21文字以上の場合" do
      it "無効であること" do
        user = build(:user, user_app: "123456789012345678901")
        user.valid?
        expect(user.errors[:user_app]).to include("は20文字以内で入力してください")
      end
    end
    context "user_timeが16文字以上の場合" do
      it "持ち時間が16文字以上ある場合無効であること" do
        user = build(:user, user_time: "1234567890123456")
        user.valid?
        expect(user.errors[:user_time]).to include("は15文字以内で入力してください")
      end
    end
    context "user_contentが101文字以上の場合" do
      it "無効であること" do
        user = build(:user, user_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
        user.valid?
        expect(user.errors[:user_content]).to include("は100文字以内で入力してください")
      end
    end
    context "passwordが8文字未満の場合" do
      it "無効であること" do
        user = build(:user, password: "1234567")
        user.valid?
        expect(user.errors[:password]).to include("は8文字以上で入力してください")
      end
    end
  end

  describe "重複のvalidate" do
    let!(:user) { create(:user) }
    context "user_nameが重複している場合" do
      it "無効であること" do
        user = build(:user, user_name: User.first.user_name)
        user.valid?
        expect(user.errors[:user_name]).to include("はすでに存在します")
      end
    end
    context "user_emailが重複している場合" do
      it "無効であること" do
        user = build(:user, email: User.first.email)
        user.valid?
        expect(user.errors[:email]).to include("はすでに存在します")
      end
    end
  end

  describe "ゲストログイン" do
    it "ゲストログインが有効な状態であること" do
      user = User.guest
      expect(user).to be_valid
    end
  end
end
