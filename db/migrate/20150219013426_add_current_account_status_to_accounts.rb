class AddCurrentAccountStatusToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :last_followers_count, :integer, default: 0
    add_column :accounts, :last_retweet_count, :integer, default: 0
    add_column :accounts, :last_favorite_count, :integer, default: 0
  end
end
