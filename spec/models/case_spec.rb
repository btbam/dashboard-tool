require 'spec_helper'

describe Case do
  it 'can be initialized' do
    expect(Case.new).to be_a(Case)
  end

  it 'has a valid factory' do
    expect(create(:case)).to be_valid
  end

  context 'validations' do
    it { should validate_presence_of :branch_id }
    it { should validate_presence_of :case_number }
    it { should validate_presence_of :policy_number }
    it { should validate_presence_of :receipt_date }
    it { should validate_presence_of :module_number }
    it { should validate_presence_of :ann_stmt_co }
  end

  context 'associations' do
    it { should belong_to :policy }
    it { should have_many :features }
  end

  context 'instance methods' do
    context '#loss_description' do
      let(:case_1) { build(:case, primary_loss_desc: 'FOO', secondary_loss_desc: 'BAR') }
      let(:case_2) { build(:case, primary_loss_desc: nil, secondary_loss_desc: 'FOO') }

      it 'concatenates and humanizes the primary and secondary loss descriptions' do
        expect(case_1.loss_description).to eql('Foo bar')
      end

      it 'does not require either or both values and ignores nulls' do
        expect(case_2.loss_description).to eql('Foo')
      end
    end
  end
end
