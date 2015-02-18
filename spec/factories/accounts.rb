# == Schema Information
#
# Table name: accounts
#
#  id          :integer          not null, primary key
#  screen_name :string(255)
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string(255)
#

FactoryGirl.define do
  factory :account do
    screen_name "MyString"
status 1
  end

end
