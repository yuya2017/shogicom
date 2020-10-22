class CreateCommunities < ActiveRecord::Migration[6.0]
  def change
    create_table :communities do |t|

      t.string :community_place, null: false
      t.date :community_date, null: false
      t.date :community_limit, null: false
      t.integer :community_money, null: false
      t.string :community_all_tag
      t.string :community_content
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
