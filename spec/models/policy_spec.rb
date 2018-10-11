require 'spec_helper'

describe Policy do
  it 'can be initialized' do
    expect(Policy.new).to be_a(Policy)
  end

  it 'has a valid factory' do
    expect(create(:policy)).to be_valid
  end

  context 'validations' do
    it { should validate_presence_of :policy_number }
    it { should validate_uniqueness_of(:policy_number).scoped_to(:module_number, :ann_stmt_co) }
    it { should validate_presence_of :module_number }
    it { should validate_uniqueness_of(:module_number).scoped_to(:policy_number, :ann_stmt_co) }
    it { should validate_presence_of :ann_stmt_co }
    it { should validate_uniqueness_of(:ann_stmt_co).scoped_to(:policy_number, :module_number) }
    it { should validate_presence_of :issuing_company }
    it { should validate_presence_of :producer_number }
    it { should validate_presence_of :dashboard_database_unique_id }
    it { should validate_uniqueness_of :dashboard_database_unique_id }
    it { should validate_presence_of :dashboard_compound_key }
  end

  context 'associations' do
    it { should have_many :cases }
    it { should have_many :features }
  end

  context 'instance methods' do
    context '#insured_name_humanize' do
      it 'returns nil if no #insured_name is present' do
        policy = Policy.new(insured_name: nil)
        expect(policy.insured_name_humanize).to be_nil
      end

      it 'strips double quotes from beginning and end of #insured_name' do
        policy = Policy.new(insured_name: '"Leroy Jenkins"')
        expect(policy.insured_name_humanize).to_not end_with('"')
        expect(policy.insured_name_humanize).to_not start_with('"')
      end

      it 'titleizes the #insured_name' do
        policy = Policy.new(insured_name: 'leroy jenkins')
        expect(policy.insured_name_humanize).to eq('Leroy Jenkins')
      end
    end
  end
end
