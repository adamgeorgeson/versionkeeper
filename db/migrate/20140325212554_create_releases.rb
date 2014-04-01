class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :accounts
      t.string :accounts_extra
      t.string :addons
      t.string :collaborate
      t.string :help
      t.string :mysageone
      t.string :payroll
      t.date :date
      t.string :notes

      t.timestamps
    end
  end
end
