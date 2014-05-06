class AddStatusToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :status, :string, :default => "UAT"
  end
end
