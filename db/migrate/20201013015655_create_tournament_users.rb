class CreateTournamentUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :tournament_users do |t|

      t.references :user, foreign_key: true, null: false
      t.references :tournament, foreign_key: true, null: false

      t.timestamps
    end
  end
end
