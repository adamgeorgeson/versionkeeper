class AddCorpTax < ActiveRecord::Migration
  def change
    add_column :releases, :sageone_corp_tax_uk, :string
  end
end
