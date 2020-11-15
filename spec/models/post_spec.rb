require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "有効な状態であること" do
    it "棋力、アプリ、持ち時間があれば有効な状態であること、" do
      expect(create(:post)).to be_valid
    end
  end

  describe "空白のvalidate" do
    it "棋力がなければ無効な状態であること" do
      post = build(:post, post_chess: nil)
      post.valid?
      expect(post.errors[:post_chess]).to include("を入力してください")
    end
    it "アプリがなければ無効な状態であること" do
      post = build(:post, post_app: nil)
      post.valid?
      expect(post.errors[:post_app]).to include("を入力してください")
    end
    it "持ち時間がなければ無効な状態であること" do
      post = build(:post, post_time: nil)
      post.valid?
      expect(post.errors[:post_time]).to include("を入力してください")
    end
    it "ユーザーがなければ無効な状態であること" do
      post = build(:post, user_id: nil)
      post.valid?
      expect(post.errors[:user_id]).to include("を入力してください")
    end

  end

  describe "文字数制限のvalidate" do
    it "棋力が11文字以上ある場合無効な状態であること" do
      post = build(:post, post_chess: "12345678901")
      post.valid?
      expect(post.errors[:post_chess]).to include("は10文字以内で入力してください")
    end
    it "アプリ名が21文字以上ある場合無効な状態であること" do
      post = build(:post, post_app: "123456789012345678901")
      post.valid?
      expect(post.errors[:post_app]).to include("は20文字以内で入力してください")
    end
    it "持ち時間が16文字以上ある場合無効な状態であること" do
      post = Post.new(post_time: "1234567890123456")
      post = build(:post, post_time: "1234567890123456")
      post.valid?
      expect(post.errors[:post_time]).to include("は15文字以内で入力してください")
    end
    it "タグが51文字以上ある場合無効な状態であること" do
      post = build(:post, post_all_tag: "123456789012345678901234567890123456789012345678901")
      post.valid?
      expect(post.errors[:post_all_tag]).to include("は50文字以内で入力してください")
    end
    it "募集内容が101文字以上ある場合無効な状態であること" do
      post = build(:post, post_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
      post.valid?
      expect(post.errors[:post_content]).to include("は100文字以内で入力してください")
    end
  end
end
