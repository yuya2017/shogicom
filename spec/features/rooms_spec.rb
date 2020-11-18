require 'rails_helper'

RSpec.feature "Rooms", type: :feature, open_on_error: true do
  scenario "投稿したらチャットルームが作成され、参加した人のみ表示されること" do
    user = create(:user)
    user2 = create(:user)
    user3 = create(:user)
    post = create(:post, user: user)
    tournament = create(:tournament, user: user)
    community = create(:community, user: user)
    Tournament.tournament_user_create(user.id, tournament.id)
    Community.community_user_create(user.id, community.id)
    post_room = create(:room, :post_room, post: post)
    tournament_room = create(:room, :tournament_room, tournament: tournament)
    community_room = create(:room, :community_room, community: community)

    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user2.email
    fill_in "パスワード*", with: user2.password
    click_button "ログイン"
    click_link "対戦相手を探す"
    expect{ click_link "個人用チャットルーム" }.to change(Room, :count).by(1)
    expect(page).to have_selector "p", text: "#{user.user_name}"
    find(".tops_icon").click
    click_link "参加済みの対戦"
    expect(page).not_to have_selector "p", text: "#{post.room.room_name}"
    find(".tops_icon").click
    click_link "参加済みの大会"
    find(".tops_icon").click
    expect(page).not_to have_selector "p", text: "#{tournament.room.room_name}"
    find(".tops_icon").click
    click_link "参加済みのイベント"
    expect(page).not_to have_selector "p", text: "#{community.room.room_name}"
    click_link "対戦相手を探す"
    find(".post-#{post.id}").click
    click_link "チャットルームへ移動"
    fill_in "message_content", with: "宜しくお願いします。"
    click_button "送信"
    visit "tops/#{user2.id}"
    click_link "参加済みの対戦"
    expect(page).to have_selector "p", text: "#{post_room.room_name}"
    click_link "大会を探す"
    find(".tournament-#{tournament.id}").click
    expect{ click_link "大会に参加" }.to change(TournamentUser, :count).by(1)
    expect(page).to have_selector "p", text: "#{tournament.room.room_name}"
    click_link "イベントを探す"
    find(".community-#{community.id}").click
    expect{ click_link "イベントに参加" }.to change(CommunityUser, :count).by(1)
    expect(page).to have_selector "p", text: "#{community.room.room_name}"
    find(".tops_icon").click
    click_link "ログアウト"
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user3.email
    fill_in "パスワード*", with: user3.password
    click_button "ログイン"
    click_link "ユーザーアイコン"
    click_link "チャットルーム"
    expect(page). not_to have_selector "p", text: "#{user.user_name}"
    find(".tops_icon").click
    click_link "ログアウト"
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user.email
    fill_in "パスワード*", with: user.password
    click_button "ログイン"
    click_link "ユーザーアイコン"
    click_link "チャットルーム"
    expect(page).to have_selector "p", text: "#{user2.user_name}"
    find(".tops_icon").click
    click_link "参加済みの対戦"
    expect(page).to have_selector "p", text: "#{post_room.room_name}"
    find(".tops_icon").click
    click_link "参加済みの大会"
    expect(page).to have_selector "p", text: "#{tournament.room.room_name}"
    find(".tops_icon").click
    click_link "参加済みのイベント"
    expect(page).to have_selector "p", text: "#{community.room.room_name}"
  end
end
