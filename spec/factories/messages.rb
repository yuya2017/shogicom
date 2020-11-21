FactoryBot.define do
  factory :message do
    message_content { "こんにちは" }

    trait :post_message do
      association :room, :post_room
      user { room.user }
    end

    trait :tournament_message do
      association :room, :tournament_room
      user { room.user }
    end

    trait :community_message do
      association :room, :community_room
      user { room.user }
    end

    trait :invalid do
      message_content { nil }
    end
  end
end
