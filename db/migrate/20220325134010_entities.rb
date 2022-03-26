class Entities < ActiveRecord::Migration[7.0]

  def self.up

    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :transactions, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :status
      t.timestamps
    end

    create_table :accounts, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :acc_number
      t.timestamps
    end

    create_table :users, id: :uuid, default: 'gen_random_uuid()' do |t|
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
