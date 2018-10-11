require 'spec_helper'

RSpec.describe Feedback, type: :model do
  it 'can be initialized' do
    expect(Feedback.new).to be_a(Feedback)
  end

  it 'has a valid factory' do
    expect(create(:feedback)).to be_valid
  end
end
