class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :name, null: false
      t.string :location, null: false

      t.timestamps
    end

    add_column :users, :college_id, :integer, null: false
    add_index :users, :college_id
  end
end
