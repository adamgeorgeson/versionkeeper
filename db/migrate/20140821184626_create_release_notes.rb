class CreateReleaseNotes < ActiveRecord::Migration
  def change
    create_table :release_notes do |t|
      t.integer :release_id, index: true
      t.text :release_notes
      t.timestamps
    end

    remove_column :releases, :user_id
    remove_column :releases, :release_notes

    drop_table :users
  end
end
