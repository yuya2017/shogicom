require 'rails_helper'

RSpec.describe "Tournaments", type: :system do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:tournament) { create(:tournament, :with_room, user: user) }

  it "ユーザーが新しい大会募集を行う" do
    sign_in user
    visit root_path
    expect {
      find('.header_icon').click
      click_link "大会開催"
      fill_in "大会名*", with: "大会"
      fill_in "応募人数",with: 3
      fill_in "応募期間*", with: "2022/02/22"
      fill_in "tournament_tournament_at_date", with: "2022/02/25"
      select "12", from: "tournament_tournament_at_hour"
      select "30", from: "tournament_tournament_at_minute"
      click_button "投稿"
    }.to change(user.tournaments, :count).by(1)
  end

  it "ユーザーは編集を行う" do
    tournament_id = tournament.id
    sign_in user
    visit root_path
    click_link "大会を探す"
    find(".tournament-#{tournament_id}").click
    click_link  "編集"
    fill_in "大会名*", with: "編集後の投稿"
    click_button "編集"
    expect(page).to have_content "更新しました。"
    click_link "大会を探す"
    expect(page).to have_selector 'h4', text: "編集後の投稿"
  end

  it "投稿者以外は編集ボタンが表示されない" do
    tournament_id = tournament.id
    sign_in user2
    visit root_path
    click_link "大会を探す"
    find(".tournament-#{tournament_id}").click
    expect(page).not_to have_selector 'a', text: "編集"
  end

  it "ユーザーは削除を行う" do
    tournament_id = tournament.id
    sign_in user
    visit root_path
    expect {
      click_link "大会を探す"
      find(".tournament-#{tournament_id}").click
      click_link "編集"
      click_link "削除"
      expect(page).to have_content "大会部屋を削除しました。"
    }.to change(user.tournaments, :count).by(-1)
  end

  it "検索画面が表示される" do
    tournament
    sign_in user
    visit root_path
    click_link "大会を探す"
    fill_in "q[tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_or_room_room_name_cont]", with: "将棋,10分,誰でも,大会部屋,30級"
    click_button "検索する"
    expect(page).to have_selector 'h4', text: "大会部屋"
    click_button "#将棋ウォーズ"
    expect(page).to have_selector 'h4', text: "大会部屋"
  end

  it "大会に参加、退出ができること"  do
    tournament_id = tournament.id
    sign_in user2
    visit root_path
    click_link "大会を探す"
    find(".tournament-#{tournament_id}").click
    expect{ click_link "大会に参加" }.to change(user2.tournament_users, :count).by(1)
    expect(page).to have_content "大会へ参加しました。"
    click_link "詳細"
    expect { click_link "退出" }.to change(user2.tournament_users, :count).by(-1)
    expect(page).to have_content "大会から抜けました。"
  end
end
