class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :account, index: true
      t.integer :followers_count
      t.integer :retweet_count
      t.integer :favorite_count

      t.timestamps null: false
    end
    add_foreign_key :histories, :accounts
  end
end
