class Entities < ActiveRecord::Migration[7.0]

  def self.up

    create_table :transactions do |t|
      t.string :status
      t.timestamps
    end

    create_table :accounts do |t|
      t.string :acc_number
      t.timestamps
    end

    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.timestamps
    end

  end

  def self.down
    drop_table :transactions
    drop_table :accounts
    drop_table :users
  end
end
