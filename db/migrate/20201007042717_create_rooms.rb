class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :room_name, null: false
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.integer :private_id

      t.timestamps
    end
  end
end
