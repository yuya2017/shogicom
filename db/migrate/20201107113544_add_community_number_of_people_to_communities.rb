class AddCommunityNumberOfPeopleToCommunities < ActiveRecord::Migration[6.0]
  def change
    add_column :communities, :community_number_of_people, :integer, after: :community_money
  end
end
