class AddCommunityRefToRooms < ActiveRecord::Migration[6.0]
  def change
    add_reference :rooms, :community, foreign_key: true, after: :tournament_id
  end
end
