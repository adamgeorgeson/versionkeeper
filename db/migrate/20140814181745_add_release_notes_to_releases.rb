class AddReleaseNotesToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :release_notes, :text
  end
end
