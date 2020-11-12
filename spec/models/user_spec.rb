require 'rails_helper'

RSpec.describe User, type: :model do
  describe "有効な状態であること" do
    it "名前、メールアドレス、棋力、アプリ、持ち時間、所在地、パスワード、確認時間があれば有効な状態であること" do
      user = User.new(
        user_name: "木下侑哉",
        email: "tester@example.com",
        user_chess: "30級",
        user_app: "将棋",
        user_time: "10分",
        user_pref: 13,
        password: "password",
        confirmed_at: Time.now
      )
      expect(user).to be_valid
    end
  end

  describe "空白のvalidate" do
    it "名前がなければ無効な状態であること" do
      user = User.new(user_name: nil)
      user.valid?
      expect(user.errors[:user_name]).to include("を入力してください")
    end
    it "メールアドレスがなければ無効な状態であること" do
      user = User.new(email: nil)
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end
    it "棋力がなければ無効な状態であること" do
      user = User.new(user_chess: nil)
      user.valid?
      expect(user.errors[:user_chess]).to include("を入力してください")
    end
    it "アプリがなければ無効な状態であること" do
      user = User.new(user_app: nil)
      user.valid?
      expect(user.errors[:user_app]).to include("を入力してください")
    end
    it "持ち時間がなければ無効な状態であること" do
      user = User.new(user_time: nil)
      user.valid?
      expect(user.errors[:user_time]).to include("を入力してください")
    end
    it "所在地がなければ無効な状態であること" do
      user = User.new(user_pref: nil)
      user.valid?
      expect(user.errors[:user_pref]).to include("を入力してください")
    end
    it "パスワードがなければ無効な状態であること" do
      user = User.new(password: nil)
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end
  end

  describe "文字数制限のvalidate" do
    it "名前が11文字以上ある場合無効であること" do
      user = User.new(user_name: "12345678901")
      user.valid?
      expect(user.errors[:user_name]).to include("は10文字以内で入力してください")
    end
    it "棋力が11文字以上ある場合無効であること" do
      user = User.new(user_chess: "12345678901")
      user.valid?
      expect(user.errors[:user_chess]).to include("は10文字以内で入力してください")
    end
    it "アプリ名が21文字以上ある場合無効であること" do
      user = User.new(user_app: "123456789012345678901")
      user.valid?
      expect(user.errors[:user_app]).to include("は20文字以内で入力してください")
    end
    it "持ち時間が16文字以上ある場合無効であること" do
      user = User.new(user_time: "1234567890123456")
      user.valid?
      expect(user.errors[:user_time]).to include("は15文字以内で入力してください")
    end
    it "自己紹介が101文字以上ある場合無効であること" do
      user = User.new(user_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
      user.valid?
      expect(user.errors[:user_content]).to include("は100文字以内で入力してください")
    end
  end

  describe "重複のvalidate" do
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
    it "重複した名前の場合無効であること" do
      user = User.new(user_name: "木下侑哉")
      user.valid?
      expect(user.errors[:user_name]).to include("はすでに存在します")
    end
    it "重複した名前の場合無効であること" do
      user = User.new(email: "tester@example.com")
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end
  end

  describe "ゲストログイン" do
    it "ゲストログインが有効な状態であること" do
      user = User.guest
      expect(user).to be_valid
    end
  end
end
