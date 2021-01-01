# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

User.create(
  [
    {user_name: "木下侑哉", user_chess: "1級", user_app: "将棋ウォーズ,将棋オンライン", user_time: "10分切れ負け", user_pref: 22, user_content: "気軽に来てください。", email: "tester@gmail.com", password: "password", confirmed_at: Time.now, admin: true, user_image: open("#{Rails.root}/db/fixtures/1.jpg")},
    {user_name: "畑中太郎", user_chess: "30級", user_app: "将棋ウォーズ", user_time: "10分切れ負け", user_pref: 1, user_content: "気軽に来てください。", email: "qwerty1@gmail.com", password: "aoyashi123", confirmed_at: Time.now, user_image: open("#{Rails.root}/db/fixtures/2.jpg")},
    {user_name: "小嶋太郎", user_chess: "25級", user_app: "将棋オンライン", user_time: "3分切れ負け", user_pref: 2, user_content: "基本誰でも募集しています。", email: "qwerty2@gmail.com", password: "ioyashi123", confirmed_at: Time.now, user_image: open("#{Rails.root}/db/fixtures/3.jpg")},
    {user_name: "芳賀花子", user_chess: "20級", user_app: "ぴよ将棋", user_time: "1手10秒", user_pref: 3, user_content: "ぜひ対戦しましょう！！", email: "uiopa1@gmail.com", password: "uoyashi123", confirmed_at: Time.now, user_image: open("#{Rails.root}/db/fixtures/4.jpg")},
    {user_name: "大井花子", user_chess: "15級", user_app: "将棋クエスト", user_time: "10分切れ負け", user_pref: 4, user_content: "初心者ですがよろしくお願いします。", email: "uiopa2@gmail.com", password: "eoyashi123", confirmed_at: Time.now, user_image: open("#{Rails.root}/db/fixtures/5.jpg")},
    {user_name: "磯部友蔵", user_chess: "10級", user_app: "将棋倶楽部24", user_time: "30分切れ負け", user_pref: 5, user_content: "基本誰でも募集しています。", email: "sdfgh1@gmail.com", password: "koyashi123", confirmed_at: Time.now, user_image: open("#{Rails.root}/db/fixtures/6.jpg")},
    {user_name: "秋田友蔵", user_chess: "5級", user_app: "どうぶつ将棋ウォーズ", user_time: "1手10秒", user_pref: 6, user_content: "どうぶつ将棋なら誰でも歓迎です。", email: "sdfgh2@gmail.com", password: "soyashi123", confirmed_at: Time.now, user_image: open("#{Rails.root}/db/fixtures/7.png")},
    {user_name: "浅見尊", user_chess: "1級", user_app: "ねこしょうぎ", user_time: "3分切れ負け", user_pref: 7, user_content: "大会をよく開くのでぜひご参加ください。", email: "jklzx1@gmail.com", password: "toyashi123", confirmed_at: Time.now, user_image: open("#{Rails.root}/db/fixtures/8.jpg")},
    {user_name: "大崎尊", user_chess: "1段", user_app: "将棋ウォーズ", user_time: "10分切れ負け", user_pref: 8, user_content: "気が向いたらイベント開催するのでお越しください。", email: "jklzx2@gmail.com", password: "noyashi123", confirmed_at: Time.now, user_image: open("#{Rails.root}/db/fixtures/9.jpg")},
    {user_name: "坪井尊", user_chess: "3段", user_app: "将棋クエスト", user_time: "1手10秒", user_pref: 9, user_content: "同じ位の方対戦しましょう。", email: "cvbnm1@gmail.com", password: "hoyashi123", confirmed_at: Time.now, user_image: open("#{Rails.root}/db/fixtures/10.jpg")},
    {user_name: "相原尊", user_chess: "5段", user_app: "将棋倶楽部24", user_time: "30分切れ負け", user_pref: 10, user_content: "段以上の方よろしくお願いいたします。", email: "cvbnm2@gmail.com", password: "moyashi123", confirmed_at: Time.now, user_image: open("#{Rails.root}/db/fixtures/11.jpg")}
  ]
)

Post.create(
  [
    {post_chess: "1級", post_app: "将棋ウォーズ,将棋オンライン", post_time: "10分切れ負け", post_all_tag: "誰でも,本日限定", post_content: "初心者ですがよろしくお願いいたします。", user_id: 1},
    {post_chess: "1級", post_app: "将棋ウォーズ", post_time: "10分切れ負け", post_all_tag: "将棋ウォーズのみ", post_content: "将棋ウォーズのみの募集ですがよろしくお願いいたします。", user_id: 1},
    {post_chess: "1級", post_app: "将棋ウォーズ", post_time: "10分切れ負け", post_all_tag: "誰でも,感想戦も希望", post_content: "感想戦も行いたいと思うのでよろしくお願いいたします。", user_id: 1},
    {post_chess: "30級", post_app: "将棋ウォーズ", post_time: "10分切れ負け", post_all_tag: "誰でも募集,初心者歓迎", post_content: "初心者ですがよろしくお願いいたします。", user_id: 2},
    {post_chess: "25級", post_app: "将棋オンライン", post_time: "3分切れ負け", post_all_tag: "", post_content: "3分切れ負けのみ募集", user_id: 3},
    {post_chess: "20級", post_app: "ぴよ将棋", post_time: "1手10秒", post_all_tag: "初心者歓迎", post_content: "誰でも募集します。", user_id: 4},
    {post_chess: "15級", post_app: "将棋クエスト", post_time: "10分切れ負け", post_all_tag: "10分切れ負けのみ", post_content: "感想戦も行いたいと思うのでよろしくお願いいたします。", user_id: 5},
    {post_chess: "10級", post_app: "将棋倶楽部24", post_time: "30分切れ負け", post_all_tag: "誰でも募集", post_content: "気軽に来てください。", user_id: 6},
    {post_chess: "5級", post_app: "どうぶつ将棋ウォーズ", post_time: "1手10秒", post_all_tag: "どうぶつ将棋,誰でも募集", post_content: "どうぶつ将棋できる方なら誰でも募集します。", user_id: 7},
    {post_chess: "1級", post_app: "ねこしょうぎ", post_time: "3分切れ負け", post_all_tag: "", post_content: "感想戦も行いたいと思うのでよろしくお願いいたします。", user_id: 8},
    {post_chess: "1段", post_app: "将棋ウォーズ", post_time: "10分切れ負け", post_all_tag: "段以上,初心者不可", post_content: "できれば段以上の方を募集します。", user_id: 9},
    {post_chess: "3段", post_app: "将棋クエスト", post_time: "1手10秒", post_all_tag: "将棋クエストのみ,本日限定", post_content: "本日のみの開催ですがよろしくお願いいたします。", user_id: 10},
    {post_chess: "5段", post_app: "将棋倶楽部24", post_time: "30分切れ負け", post_all_tag: "長期戦のみ,感想戦希望", post_content: "感想戦も行いたいと思うのでよろしくお願いいたします。", user_id: 11}
  ]
)

Tournament.create(
  [
    {tournament_chess: "1級", tournament_app: "将棋ウォーズ,将棋オンライン", tournament_time: "10分切れ負け", tournament_all_tag: "誰でも", tournament_content: "初開催ですがよろしくお願いいたします。", tournament_number_of_people: 10, tournament_limit: Date.today + 5, tournament_at_date: Date.today + 10, tournament_at_hour: 9, tournament_at_minute: 00, user_id: 1},
    {tournament_chess: "1級", tournament_app: "将棋ウォーズ", tournament_time: "10分切れ負け", tournament_all_tag: "将棋ウォーズのみ", tournament_content: "将棋ウォーズのみの大会です。よければご参加ください。", tournament_limit: Date.today + 3, tournament_at_date: Date.today + 5, tournament_at_hour: 12, tournament_at_minute: 00, user_id: 1},
    {tournament_chess: "1級", tournament_app: "将棋ウォーズ", tournament_time: "10分切れ負け", tournament_all_tag: "感想戦も希望", tournament_content: "対戦後はグループ内で感想戦もできたらいいなと思っています。", tournament_number_of_people: 10 ,tournament_limit: Date.today + 5, tournament_at_date: Date.today + 13, tournament_at_hour: 18, tournament_at_minute: 00, user_id: 1},
    {tournament_chess: "30級", tournament_app: "将棋ウォーズ", tournament_time: "10分切れ負け", tournament_all_tag: "誰でも募集,初心者歓迎", tournament_content: "初心者大歓迎の大会です。よろしくお願いいたします。", tournament_number_of_people: 10 ,tournament_limit: Date.today + 5, tournament_at_date: Date.today + 18, tournament_at_hour: 20, tournament_at_minute: 00, user_id: 2},
    {tournament_chess: "25級", tournament_app: "将棋オンライン", tournament_time: "3分切れ負け",tournament_all_tag: "", tournament_content: "3分切れ負けのみの早指し大会です。", tournament_number_of_people: 10 ,tournament_limit: Date.today + 10, tournament_at_date: Date.today + 20, tournament_at_hour: 11, tournament_at_minute: 00, user_id: 3},
    {tournament_chess: "20級", tournament_app: "ぴよ将棋", tournament_time: "1手10秒", tournament_all_tag: "初心者歓迎", tournament_content: "誰でも募集します。", tournament_number_of_people: 10 ,tournament_limit: Date.today + 9, tournament_at_date: Date.today + 12, tournament_at_hour: 13, tournament_at_minute: 00, user_id: 4},
    {tournament_chess: "15級", tournament_app: "将棋クエスト", tournament_time: "10分切れ負け", tournament_all_tag: "10分切れ負けのみ", tournament_content: "誰でも募集します。", tournament_limit: Date.today + 5, tournament_at_date: Date.today + 10, tournament_at_hour: 12, tournament_at_minute: 00, user_id: 5},
    {tournament_chess: "10級", tournament_app: "将棋倶楽部24", tournament_time: "30分切れ負け", tournament_all_tag: "誰でも募集", tournament_content: "長期戦の大会を開催します。", tournament_number_of_people: 10 ,tournament_limit: Date.today + 14, tournament_at_date: Date.today + 16, tournament_at_hour: 18, tournament_at_minute: 00, user_id: 6},
    {tournament_chess: "5級", tournament_app: "どうぶつ将棋ウォーズ", tournament_time: "1手10秒", tournament_all_tag: "どうぶつ将棋,誰でも募集", tournament_content: "どうぶつ将棋できる方なら誰でも募集します。", tournament_number_of_people: 10 ,tournament_limit: Date.today + 5, tournament_at_date: Date.today + 16, tournament_at_hour: 19, tournament_at_minute: 00, user_id: 7},
    {tournament_chess: "1級", tournament_app: "ねこしょうぎ", tournament_time: "3分切れ負け",tournament_all_tag: "", tournament_content: "ねこ将棋をやっている方はぜひ参加ください。", tournament_number_of_people: 10 ,tournament_limit: Date.today + 3, tournament_at_date: Date.today + 5, tournament_at_hour: 15, tournament_at_minute: 00, user_id: 8},
    {tournament_chess: "1段", tournament_app: "将棋ウォーズ", tournament_time: "10分切れ負け", tournament_all_tag: "段以上,初心者不可", tournament_content: "段以上の方限定で開催します。", tournament_number_of_people: 10 ,tournament_limit: Date.today + 7, tournament_at_date: Date.today + 13, tournament_at_hour: 10, tournament_at_minute: 00, user_id: 9},
    {tournament_chess: "3段", tournament_app: "将棋クエスト", tournament_time: "1手10秒", tournament_all_tag: "将棋クエストのみ,本日限定", tournament_content: "急ですが開催します。", tournament_limit: Date.today + 1, tournament_at_date: Date.today + 2, tournament_at_hour: 20, tournament_at_minute: 00, user_id: 10},
    {tournament_chess: "5段", tournament_app: "将棋倶楽部24", tournament_time: "30分切れ負け", tournament_all_tag: "長期戦のみ,感想戦希望", tournament_content: "長期戦の大会です。", tournament_number_of_people: 10 ,tournament_limit: Date.today + 5, tournament_at_date: Date.today + 14, tournament_at_hour: 12, tournament_at_minute: 00, user_id: 11}
  ]
)

Community.create(
  [
    {community_place: "静岡県浜松市", community_money: 1000, community_all_tag: "誰でも", community_content: "初開催ですがよろしくお願いいたします。", community_number_of_people: 10, community_limit: Date.today + 5, community_date: Date.today + 10, user_id: 1},
    {community_place: "静岡県掛川市", community_money: 0, community_all_tag: "5人以上集まったら開催", community_content: "近くの方よろしくお願いします。", community_limit: Date.today + 3, community_date: Date.today + 11, user_id: 1},
    {community_place: "静岡県藤枝市", community_money: 2000, community_all_tag: "誰でも募集", community_content: "誰でも募集します。", community_number_of_people: 10, community_limit: Date.today + 10, community_date: Date.today + 20, user_id: 1},
    {community_place: "芽室町中央公民館", community_money: 1000, community_all_tag: "誰でも", community_content: "日程の変更可能ですので気軽にチャットください。", community_number_of_people: 10, community_limit: Date.today + 12, community_date: Date.today + 18, user_id: 2},
    {community_place: "青森県弘前市", community_money: 0, community_all_tag: "誰でも", community_content: "参加費無料、誰でもご参加いただけますので気軽に来てください。", community_number_of_people: 10, community_limit: Date.today + 12, community_date: Date.today + 18, user_id: 3},
    {community_place: "岩手県盛岡市", community_money: 1000, community_all_tag: "日程調整可能", community_content: "不明な点はチャットルームへ気軽にコメントください。", community_number_of_people: 10, community_limit: Date.today + 15, community_date: Date.today + 30, user_id: 4},
    {community_place: "宮城県大崎市", community_money: 1000, community_all_tag: "誰でも", community_content: "近くの方よろしくお願いします。", community_number_of_people: 10, community_limit: Date.today + 20, community_date: Date.today + 28, user_id: 5},
    {community_place: "秋田県横手市", community_money: 1000, community_all_tag: "誰でも", community_content: "気軽にご参加ください。", community_number_of_people: 10, community_limit: Date.today + 22, community_date: Date.today + 38, user_id: 6},
    {community_place: "鶴岡市中央公民館", community_money: 1000, community_all_tag: "誰でも", community_content: "募集制限ありませんので気軽に参加してください。", community_number_of_people: 10, community_limit: Date.today + 7, community_date: Date.today + 18, user_id: 7},
    {community_place: "大成地域公民館", community_money: 0, community_all_tag: "誰でも", community_content: "参加費無料なので、気軽に参加ください。", community_number_of_people: 10, community_limit: Date.today + 10, community_date: Date.today + 22, user_id: 8},
    {community_place: "茨城県那珂市", community_money: 1000, community_all_tag: "誰でも", community_content: "年齢問わず募集します。", community_number_of_people: 10, community_limit: Date.today + 12, community_date: Date.today + 18, user_id: 9},
    {community_place: "稲村公民館", community_money: 1000, community_all_tag: "駒落ち予定", community_content: "駒落ちによる大会を予定していますので初心者のかたも気軽にご参加ください。", community_number_of_people: 10, community_limit: Date.today + 20, community_date: Date.today + 30, user_id: 10},
    {community_place: "横塚町公民館", community_money: 2000, community_all_tag: "誰でも", community_content: "大会を開催し、上位者には簡単な景品も用意したいと思います。", community_limit: Date.today + 22, community_date: Date.today + 42, user_id: 11}
  ]
)

Room.create(
  [
    {room_name: "木下部屋", user_id: 1, post_id: 1},
    {room_name: "将棋ウォーズ限定部屋", user_id: 1, post_id: 2},
    {room_name: "感想戦希望部屋", user_id: 1, post_id: 3},
    {room_name: "初心者歓迎", user_id: 2, post_id: 4},
    {room_name: "早指し部屋", user_id: 3, post_id: 5},
    {room_name: "ぴよ将棋部屋", user_id: 4, post_id: 6},
    {room_name: "将棋クエスト募集", user_id: 5, post_id: 7},
    {room_name: "長期戦部屋", user_id: 6, post_id: 8},
    {room_name: "どうぶつ将棋", user_id: 7, post_id: 9},
    {room_name: "ねこしょうぎ部屋", user_id: 8, post_id: 10},
    {room_name: "段以上限定部屋", user_id: 9, post_id: 11},
    {room_name: "将棋クエスト限定", user_id: 10, post_id: 12},
    {room_name: "長期戦部屋", user_id: 11, post_id: 13},
    {room_name: "木下大会", user_id: 1, tournament_id: 1},
    {room_name: "将棋ウォーズ限定大会", user_id: 1, tournament_id: 2},
    {room_name: "感想戦希望大会", user_id: 1, tournament_id: 3},
    {room_name: "初心者歓迎大会", user_id: 2, tournament_id: 4},
    {room_name: "早指し部屋大会", user_id: 3, tournament_id: 5},
    {room_name: "ぴよ将棋大会部屋", user_id: 4, tournament_id: 6},
    {room_name: "将棋クエスト大会", user_id: 5, tournament_id: 7},
    {room_name: "長期戦大会", user_id: 6, tournament_id: 8},
    {room_name: "どうぶつ将棋大会", user_id: 7, tournament_id: 9},
    {room_name: "ねこしょうぎ大会", user_id: 8, tournament_id: 10},
    {room_name: "段以上限定大会", user_id: 9, tournament_id: 11},
    {room_name: "将棋クエスト大会", user_id: 10, tournament_id: 12},
    {room_name: "長期戦大会", user_id: 11, tournament_id: 13},
    {room_name: "浜松市イベント", user_id: 1, community_id: 1},
    {room_name: "掛川市イベント", user_id: 1, community_id: 2},
    {room_name: "静岡県イベント", user_id: 1, community_id: 3},
    {room_name: "北海道イベント", user_id: 2, community_id: 4},
    {room_name: "参加費無料のイベント", user_id: 3, community_id: 5},
    {room_name: "冬の将棋イベント", user_id: 4, community_id: 6},
    {room_name: "大崎市イベント", user_id: 5, community_id: 7},
    {room_name: "横手市市イベント", user_id: 6, community_id: 8},
    {room_name: "鶴岡市イベント", user_id: 7, community_id: 9},
    {room_name: "大成地域イベント", user_id: 8, community_id: 10},
    {room_name: "福田イベント", user_id: 9, community_id: 11},
    {room_name: "稲村イベント", user_id: 10, community_id: 12},
    {room_name: "横塚町イベント", user_id: 11, community_id: 13},
    {room_name: "個人用チャットルーム", user_id: 1, private_id: 2},
    {room_name: "個人用チャットルーム", user_id: 1, private_id: 3},
    {room_name: "個人用チャットルーム", user_id: 1, private_id: 4}
  ]
)

TournamentUser.create(
  [
    {user_id: 1, tournament_id: 1},
    {user_id: 1, tournament_id: 2},
    {user_id: 1, tournament_id: 3},
    {user_id: 2, tournament_id: 4},
    {user_id: 3, tournament_id: 5},
    {user_id: 4, tournament_id: 6},
    {user_id: 5, tournament_id: 7},
    {user_id: 6, tournament_id: 8},
    {user_id: 7, tournament_id: 9},
    {user_id: 8, tournament_id: 10},
    {user_id: 9, tournament_id: 11},
    {user_id: 10, tournament_id: 12},
    {user_id: 11, tournament_id: 13},
    {user_id: 1, tournament_id: 2}
  ]
)

CommunityUser.create(
  [
    {user_id: 1, community_id: 1},
    {user_id: 1, community_id: 2},
    {user_id: 1, community_id: 3},
    {user_id: 2, community_id: 4},
    {user_id: 3, community_id: 5},
    {user_id: 4, community_id: 6},
    {user_id: 5, community_id: 7},
    {user_id: 6, community_id: 8},
    {user_id: 7, community_id: 9},
    {user_id: 8, community_id: 10},
    {user_id: 9, community_id: 11},
    {user_id: 10, community_id: 12},
    {user_id: 11, community_id: 13},
    {user_id: 6, community_id: 1},
    {user_id: 1, community_id: 7}
  ]
)

Message.create(
  [
    {message_content: "はじめまして。", user_id: 1, room_id: 1},
    {message_content: "よろしくお願いいたします。", user_id: 2, room_id: 1},
    {message_content: "お願いします。", user_id: 3, room_id: 2},
    {message_content: "はじめまして。", user_id: 2, room_id: 40},
    {message_content: "よろしくお願いします。", user_id: 5, room_id: 14},
    {message_content: "よろしくお願いします。", user_id: 7, room_id: 27},
    {message_content: "はじめまして。", user_id: 10, room_id: 28}
  ]
)
