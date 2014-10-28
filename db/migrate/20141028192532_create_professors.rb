class CreateProfessors < ActiveRecord::Migration
  def change
    create_table :professors do |t|
      t.string :first_name, null: false
      t.string :middle_initial
      t.string :last_name, null: false
      t.integer :college_id, null: false
      t.string :department, null: false

      t.timestamps
    end

    add_index :professors, :college_id
  end
end
