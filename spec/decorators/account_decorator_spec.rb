# coding: utf-8
require 'rails_helper'

describe AccountDecorator do
  let(:account) { Account.new.extend AccountDecorator }
  subject { account }
  it { should be_a Account }
end
