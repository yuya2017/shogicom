require 'rails_helper'

RSpec.describe Post, type: :model do
  context "post_chess,post_app,post_timeが存在する場合" do
    it "有効な状態であること、" do
      expect(create(:post)).to be_valid
    end
  end

  describe "空白のvalidate" do
    context "post_chessが存在しない場合" do
      it "無効な状態であること" do
        post = build(:post, post_chess: nil)
        post.valid?
        expect(post.errors[:post_chess]).to include("を入力してください")
      end
    end
    context "post_appが存在しない場合" do
      it "無効な状態であること" do
        post = build(:post, post_app: nil)
        post.valid?
        expect(post.errors[:post_app]).to include("を入力してください")
      end
    end
    context "user_timeが存在しない場合" do
      it "無効な状態であること" do
        post = build(:post, post_time: nil)
        post.valid?
        expect(post.errors[:post_time]).to include("を入力してください")
      end
    end
    context "user_idが存在しない場合" do
      it "無効な状態であること" do
        post = build(:post, user_id: nil)
        post.valid?
        expect(post.errors[:user_id]).to include("を入力してください")
      end
    end
  end

  describe "文字数制限のvalidate" do
    context "post_chessが11文字以上の場合" do
      it "無効な状態であること" do
        post = build(:post, post_chess: "12345678901")
        post.valid?
        expect(post.errors[:post_chess]).to include("は10文字以内で入力してください")
      end
    end
    context "post_appが21文字以上の場合" do
      it "無効な状態であること" do
        post = build(:post, post_app: "123456789012345678901")
        post.valid?
        expect(post.errors[:post_app]).to include("は20文字以内で入力してください")
      end
    end
    context "post_timeが16文字以上の場合" do
      it "無効な状態であること" do
        post = build(:post, post_time: "1234567890123456")
        post.valid?
        expect(post.errors[:post_time]).to include("は15文字以内で入力してください")
      end
    end
    context "post_all_tagが51文字以上の場合" do
      it "無効な状態であること" do
        post = build(:post, post_all_tag: "123456789012345678901234567890123456789012345678901")
        post.valid?
        expect(post.errors[:post_all_tag]).to include("は50文字以内で入力してください")
      end
    end
    context "post_contentが101文字以上の場合"
    it "無効な状態であること" do
      post = build(:post, post_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
      post.valid?
      expect(post.errors[:post_content]).to include("は100文字以内で入力してください")
    end
  end
end
