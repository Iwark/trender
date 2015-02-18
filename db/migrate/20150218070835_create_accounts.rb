class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :screen_name
      t.integer :status

      t.timestamps null: false
    end
  end
end
