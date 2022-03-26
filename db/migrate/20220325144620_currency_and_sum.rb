class CurrencyAndSum < ActiveRecord::Migration[7.0]

  def self.up
    add_column :transactions, :sum, :float
    add_column :transactions, :currency, :string
    add_column :accounts, :sum, :float
    add_column :accounts, :currency, :string
    add_column :requests, :sum, :float
    add_column :requests, :currency, :string
  end

  def self.down
    remove_column :transactions, :sum
    remove_column :transactions, :currency
    remove_column :accounts, :sum
    remove_column :accounts, :currency
    remove_column :requests, :sum
    remove_column :requests, :currency
  end
end
