require 'spec_helper'

describe User do
  it 'can be initialized' do
    expect(User.new).to be_a(User)
  end

  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  context 'validations' do
    context 'pre-registration' do
      before { allow(subject).to receive(:finished_registration).and_return(false) }

      it { should allow_value(nil).for(:name_first) }
      it { should allow_value(nil).for(:name_last) }
      it { should validate_presence_of :email }
      it { should validate_uniqueness_of :email }
    end

    context 'post-registration' do
      before { allow(subject).to receive(:finished_registration).and_return(true) }

      it { should validate_presence_of :name_first }
      it { should validate_presence_of :name_last }
      it { should validate_presence_of :email }
      it { should validate_uniqueness_of :email }
    end
  end

  context 'associations' do
    it { should have_many :roles }
    it { should have_many :role_permissions }
  end
end
