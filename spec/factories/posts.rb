FactoryBot.define do
  factory :post do
    post_chess { "30級" }
    post_app { "将棋ウォーズ" }
    post_time { "10分" }
    post_all_tag { "誰でも可" }
    post_content { "制限なく募集します。" }
    association :user

    trait :with_room do
      room_attributes { attributes_for(:room, :post_room) }
    end
    trait :with_room_update do
      post_chess { "1級" }
    end
    trait :invalid do
      post_chess { nil }
    end
  end
end
