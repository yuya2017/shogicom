class CreateCommunityUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :community_users do |t|
      t.references :user, foreign_key: true, null: false
      t.references :community, foreign_key: true, null: false

      t.timestamps
    end
  end
end
