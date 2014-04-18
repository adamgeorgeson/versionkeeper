class ChangeNotesType < ActiveRecord::Migration
  def up
    change_column :releases, :notes, :text
  end

  def down
    change_column :releases, :notes, :string
  end
end
