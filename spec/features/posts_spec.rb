require 'rails_helper'

RSpec.feature "Posts", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:post) { create(:post, :with_room, user: user) }

  scenario "ユーザーが新しい対戦相手募集を行う" do
    sign_in user
    visit root_path
    find('.header_icon').click
    click_link "対戦"
      expect {
      fill_in "部屋名*", with: "オンライン対戦"
      click_button "投稿"
      expect(page).to have_content "オンライン対戦を作成しました。"
    }.to change(user.posts, :count).by(1)
  end

  scenario "ユーザーは編集を行う" do
    post_id = post.id
    sign_in user
    visit root_path
    click_link "対戦相手を探す"
    find(".post-#{post_id}").click
    click_link "編集"
    fill_in "部屋名*", with: "編集後の投稿"
    click_button "編集"
    expect(page).to have_content "更新しました。"
    click_link "対戦相手を探す"
    expect(page).to have_selector 'h4', text: "編集後の投稿"
  end

  scenario "投稿者以外は編集ボタンが表示されない" do
    post_id = post.id
    sign_in user2
    visit root_path
    click_link "対戦相手を探す"
    find(".post-#{post_id}").click
    expect(page).not_to have_selector 'a', text: "編集"
  end

  scenario "ユーザーは削除を行う" do
    post_id = post.id
    sign_in user
    visit root_path
    click_link "対戦相手を探す"
    find(".post-#{post_id}").click
    click_link "編集"
    expect {
      click_link "削除"
      expect(page).to have_content "#{post.room.room_name}を削除しました。"
    }.to change(user.posts, :count).by(-1)
  end

  scenario "検索画面が表示される" do
    post_id = post.id
    sign_in user
    visit root_path
    click_link "対戦相手を探す"
    fill_in "q[post_chess_or_post_app_or_post_time_or_post_all_tag_or_room_room_name_cont]", with: "将棋ウォーズ,30級,10分,誰でも,オンライン対戦部屋"
    click_button "検索する"
    expect(page).to have_selector 'h4', text: "オンライン対戦部屋"
  end
end
