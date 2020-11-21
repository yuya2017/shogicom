FactoryBot.define do
  factory :room do
    room_name { "個人用チャットルーム" }
    association :user

    trait :post_room do
      room_name { "オンライン対戦部屋" }
      association :post
      user { post.user }
    end
    trait :tournament_room do
      room_name { "大会部屋" }
      association :tournament
      user { tournament.user }
    end
    trait :community_room do
      room_name { "イベント部屋" }
      association :community
      user { community.user }
    end
    
  end
end
