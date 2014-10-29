class CreateCollegeRatings < ActiveRecord::Migration
  def change
    create_table :college_ratings do |t|
      t.integer :college_id, null: false
      t.integer :rater_id, null: false
      t.integer :reputation, null: false
      t.integer :location, null: false
      t.integer :opportunities, null: false
      t.integer :library, null: false
      t.integer :grounds_and_common_areas, null: false
      t.integer :internet, null: false
      t.integer :food, null: false
      t.integer :clubs, null: false
      t.integer :social, null: false
      t.integer :happiness, null: false
      t.integer :graduation_year, null: false
      t.text :comments

      t.timestamps
    end
    
    add_index :college_ratings, :college_id
    add_index :college_ratings, :rater_id
    add_index :college_ratings, [:college_id, :rater_id], unique: true
  end
end
