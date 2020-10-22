class AddTournamentRefToRooms < ActiveRecord::Migration[6.0]
  def change
    add_reference :rooms, :tournament, foreign_key: true, after: :post_id
  end
end
