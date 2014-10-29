class CreateProfessorRatings < ActiveRecord::Migration
  def change
    create_table :professor_ratings do |t|
      t.integer :professor_id, null: false
      t.integer :rater_id, null: false
      t.string :course_code, null: false
      t.boolean :online_class, default: false
      t.integer :helpfulness, null: false
      t.integer :clarity, null: false
      t.integer :easiness, null: false
      t.boolean :taken_for_credit, default: true
      t.boolean :hotness, default: false
      t.text :comments
      t.boolean :attendance_is_mandatory, default: false
      t.integer :interest
      t.integer :textbook_use
      t.string :grade_received, null: false
      
      t.timestamps
    end
    
    add_index :professor_ratings, :professor_id
    add_index :professor_ratings, :rater_id
    add_index :professor_ratings, [:professor_id, :rater_id], unique: true
  end
end
