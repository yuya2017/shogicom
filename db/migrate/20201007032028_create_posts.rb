class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :post_chess, null: false
      t.string :post_app, null: false
      t.string :post_time, null: false
      t.string :post_all_tag
      t.string :post_content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
