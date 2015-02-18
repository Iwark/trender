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

require 'rails_helper'

RSpec.describe Account, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
