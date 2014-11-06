class AddDefaultToFilepickerUrlColumn < ActiveRecord::Migration
  def change
    change_column :professors, :filepicker_url, :string, default: "https://www.filepicker.io/api/file/OOgUvrkDQJC2BkXhi8RG"
  end
end
