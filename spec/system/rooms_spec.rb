require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:post) { create(:post, :with_room, user: user) }
  let!(:tournament) { create(:tournament, :with_room, user: user) }
  let!(:community) { create(:community, :with_room, user: user) }
  let!(:tournament_user) { Tournament.tournament_user_create(user.id, tournament.id) }
  let!(:community_user) { Community.community_user_create(user.id, community.id) }

  it "個人用チャットルームが作成されること" do
    sign_in user2
    visit root_path
    click_link "対戦相手を探す"
    expect{ click_link "個人用チャットルーム" }.to change(Room, :count).by(1)
    expect(page).to have_selector "p", text: "#{user.user_name}"
  end

  it "相手の個人用チャットルームが表示される" do
    create(:room, user: user, private_id: user2.id)
    sign_in user2
    visit root_path
    click_link "ユーザーアイコン"
    click_link "チャットルーム"
    expect(page).to have_selector "p", text: "#{user.user_name}"
  end

  it "投稿した人のmypageに表示されること" do
    create(:room, user: user, private_id: user2.id)
    sign_in user
    visit root_path
    click_link "ユーザーアイコン"
    click_link "参加済みの対戦"
    expect(page).to have_selector "p", text: "#{post.room.room_name}"
    find(".tops_icon").click
    click_link "参加済みの大会"
    expect(page).to have_selector "p", text: "#{tournament.room.room_name}"
    find(".tops_icon").click
    click_link "参加済みのイベント"
    expect(page).to have_selector "p", text: "#{community.room.room_name}"
    find(".tops_icon").click
    click_link "チャットルーム"
    expect(page).to have_selector "p", text: "#{user2.user_name}"
  end

  it "参加していない人のmypageには表示されないこと" do
    sign_in user2
    visit root_path
    click_link "ユーザーアイコン"
    click_link "参加済みの対戦"
    expect(page).not_to have_selector "p", text: "#{post.room.room_name}"
    find(".tops_icon").click
    click_link "参加済みの大会"
    expect(page).not_to have_selector "p", text: "#{tournament.room.room_name}"
    find(".tops_icon").click
    click_link "参加済みのイベント"
    expect(page).not_to have_selector "p", text: "#{community.room.room_name}"
    find(".tops_icon").click
  end

  it "参加すればmypageに表示されること", js:true do
    sign_in user2
    visit root_path
    find(".top_post_search").click
    find(".post-#{post.id}").click
    click_link "チャットルームへ移動"
    fill_in "message_content", with: "宜しくお願いします。"
    click_button "送信"
    expect(page).to have_selector "p", text: "宜しくお願いします。"
    click_link "大会を探す"
    find(".tournament-#{tournament.id}").click
    expect{ click_link "大会に参加" }.to change(TournamentUser, :count).by(1)
    expect(page).to have_selector "p", text: "#{tournament.room.room_name}"
    fill_in "message_content", with: "宜しくお願いします。"
    click_button "送信"
    expect(page).to have_selector "p", text: "宜しくお願いします。"
    click_link "イベントを探す"
    find(".community-#{community.id}").click
    expect{ click_link "イベントに参加" }.to change(CommunityUser, :count).by(1)
    expect(page).to have_selector "p", text: "#{community.room.room_name}"
    fill_in "message_content", with: "宜しくお願いします。"
    click_button "送信"
    expect(page).to have_selector "p", text: "宜しくお願いします。"
  end

end
