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

FactoryGirl.define do
  factory :history do
    account nil
followers_count 1
retweet_count 1
favorite_count 1
  end

end
