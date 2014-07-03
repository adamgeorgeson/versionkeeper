class AddAdProductsToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :accountant_edition, :string
    add_column :releases, :accounts_production, :string
  end
end
