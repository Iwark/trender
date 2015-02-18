# == Schema Information
#
# Table name: histories
#
#  id              :integer          not null, primary key
#  account_id      :integer
#  followers_count :integer
#  retweet_count   :integer
#  favorite_count  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class History < ActiveRecord::Base
  belongs_to :account
end
