require 'spec_helper'

describe Alert do
  it 'can be initialized' do
    expect(Alert.new).to be_a(Alert)
  end

  # it 'has a valid factory' do
  #   expect(create(:adjuster)).to be_valid
  # end
end
