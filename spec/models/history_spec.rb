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

require 'rails_helper'

RSpec.describe History, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
