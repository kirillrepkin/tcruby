class EntityRelations < ActiveRecord::Migration[7.0]

  def change
    add_reference :transactions, :account, foreign_key: true, type: :uuid
    add_reference :accounts, :user, foreign_key: true, type: :uuid
  end

end
