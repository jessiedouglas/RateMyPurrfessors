class CreateUpDownVotes < ActiveRecord::Migration
  def change
    create_table :up_down_votes do |t|
      t.integer :voter_id, null: false
      t.integer :vote_value, null: false
      t.string :votable_type, null: false
      t.integer :votable_id, null: false

      t.timestamps
    end
    
    add_index :up_down_votes, :voter_id
    add_index :up_down_votes, [:voter_id, :votable_type, :votable_id], unique: true
  end
end
