# == Schema Information
#
# Table name: accounts
#
#  id                   :integer          not null, primary key
#  screen_name          :string(255)
#  status               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  name                 :string(255)
#  last_followers_count :integer          default("0")
#  last_retweet_count   :integer          default("0")
#  last_favorite_count  :integer          default("0")
#

require 'rails_helper'

RSpec.describe Account, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
