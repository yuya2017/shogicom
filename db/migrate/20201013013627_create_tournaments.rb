class CreateTournaments < ActiveRecord::Migration[6.0]
  def change
    create_table :tournaments do |t|

      t.string :tournament_chess, null: false
      t.string :tournament_app, null: false
      t.string :tournament_time, null: false
      t.string :tournament_all_tag
      t.string :tournament_content
      t.string :tournament_number_of_people
      t.date :tournament_limit, null: false
      t.datetime :tournament_date, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
