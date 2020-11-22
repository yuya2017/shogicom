FactoryBot.define do
  factory :community do
    community_place { "東京都" }
    community_limit { Date.today >> 1 }
    community_date { Date.today >> 2 }
    community_money { 0 }
    community_number_of_people { 10 }
    community_all_tag{ "誰でも可" }
    community_content{ "宜しくお願いいたします。" }
    association :user

    trait :with_room do
      room_attributes { attributes_for(:room, :community_room) }
    end

    trait :with_update do
      community_place { "静岡県" }
    end

    trait :invalid do
      community_place { nil }
    end

    trait :limit_before do
      community_limit { Date.today << 1 }
    end

    trait :limit_today do
      community_limit { Date.today }
    end

    trait :date_before do
      community_limit { Date.today >> 2 }
      community_date { Date.today >> 1 }
    end

    trait :date_same_limit do
      community_limit { Date.today >> 2 }
      community_date { Date.today >> 2 }
    end

    trait :limit_over do
      community_limit { Date.today << 1 }
      community_date { Date.today >> 2 }
    end

  end
end
