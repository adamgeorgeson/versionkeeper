class AddCordinator < ActiveRecord::Migration
  def change
    add_column :releases, :coordinator, :string
  end
end

