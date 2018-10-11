require 'spec_helper'

RSpec.describe Ability do
  let(:ability) { Ability.new(user) }
  let(:user) { nil }

  # context 'when a user exists' do
  #   let(:user) { create(:user) }
  #   it 'can manage all' do
  #     expect(ability.can?(:manage, :all)).to be_truthy
  #   end
  # end
end
