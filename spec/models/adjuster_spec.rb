require 'spec_helper'

describe Adjuster do
  it 'can be initialized' do
    expect(Adjuster.new).to be_a(Adjuster)
  end

  it 'has a valid factory' do
    expect(create(:adjuster)).to be_valid
  end

  context 'validations' do
    it { should validate_presence_of :adjuster_id }
    it { should validate_uniqueness_of :adjuster_id }
    it { should validate_presence_of :name }
    it { should_not validate_presence_of :dashboard_claim_unique_id }
    it { should_not validate_presence_of :dashboard_claim_manager_unique_id }
  end

  context 'associations' do
    it { should have_many :notes }
    it { should have_many :features }
  end

  context 'scopes' do
    context '::named_like' do
      let!(:feature_o) { create(:feature, claim_status: 'O') }
      let!(:jaime) { create(:adjuster, name: 'Jaime Lannister') }
      it 'includes adjusters with names that start with the specified text' do
        feature_o.update_attributes(adjuster: jaime)
        expect(Adjuster.named_like('Jaim')).to include(jaime)
      end

      it 'should be case-insensitive' do
        feature_o.update_attributes(adjuster: jaime)
        expect(Adjuster.named_like('jAiM')).to include(jaime)
      end

      it 'does not include adjusters with names that do not start with the specified text' do
        expect(Adjuster.named_like('Hodor')).to_not include(jaime)
      end
    end
  end

  context 'class methods' do
    let!(:the_king) { FactoryGirl.create(:adjuster, manager_id: 1) }
    (1..3).each do |first_i|
      let!(('vp_'+first_i.to_s).to_sym) { FactoryGirl.create(:adjuster, manager_id: the_king.adjuster_id) }
      (1..3).each do |second_i|
        let!(('sub_vp_'+first_i.to_s+'_'+second_i.to_s).to_sym) do
          FactoryGirl.create(:adjuster, manager_id: eval('vp_'+first_i.to_s).adjuster_id)
        end
        (1..3).each do |third_i|
          let!(('adjuster_'+first_i.to_s+'_'+second_i.to_s+'_'+third_i.to_s).to_sym) do
            FactoryGirl.create(:adjuster, manager_id: eval('sub_vp_'+first_i.to_s+'_'+second_i.to_s).adjuster_id)
          end
        end
      end
    end

    context '#all_subordinates' do
      it 'returns all subordinates for adjuster_3_3_1' do
        expect(Adjuster.all_subordinates(adjuster_3_3_1.adjuster_id)).to contain_exactly()
      end
      it 'returns all subordinates for adjuster_2_3_1' do
        expect(Adjuster.all_subordinates(adjuster_2_3_1.adjuster_id)).to contain_exactly()
      end
      it 'returns all subordinates for adjuster_1_1_3' do
        expect(Adjuster.all_subordinates(adjuster_1_1_3.adjuster_id)).to contain_exactly()
      end

      it 'returns all subordinates for sub_vp_1_1' do
        expect(Adjuster.all_subordinates(sub_vp_1_1.adjuster_id)).to contain_exactly(adjuster_1_1_1.adjuster_id,
                                                                                     adjuster_1_1_2.adjuster_id,
                                                                                     adjuster_1_1_3.adjuster_id)
      end

      it 'returns all subordinates for sub_vp_2_3' do
        expect(Adjuster.all_subordinates(sub_vp_2_3.adjuster_id)).to contain_exactly(adjuster_2_3_1.adjuster_id,
                                                                                     adjuster_2_3_2.adjuster_id,
                                                                                     adjuster_2_3_3.adjuster_id)
      end

      it 'returns all subordinates for sub_vp_3_2' do
        expect(Adjuster.all_subordinates(sub_vp_3_2.adjuster_id)).to contain_exactly(adjuster_3_2_1.adjuster_id,
                                                                                     adjuster_3_2_2.adjuster_id,
                                                                                     adjuster_3_2_3.adjuster_id)
      end

      it 'returns all subordinates for vp_1' do
        expect(Adjuster.all_subordinates(vp_1.adjuster_id)).to contain_exactly(sub_vp_1_1.adjuster_id,
                                                                               sub_vp_1_2.adjuster_id,
                                                                               sub_vp_1_3.adjuster_id,
                                                                               adjuster_1_1_1.adjuster_id,
                                                                               adjuster_1_1_2.adjuster_id,
                                                                               adjuster_1_1_3.adjuster_id,
                                                                               adjuster_1_2_1.adjuster_id,
                                                                               adjuster_1_2_2.adjuster_id,
                                                                               adjuster_1_2_3.adjuster_id,
                                                                               adjuster_1_3_1.adjuster_id,
                                                                               adjuster_1_3_2.adjuster_id,
                                                                               adjuster_1_3_3.adjuster_id
                                                                               )
      end

      it 'returns all subordinates for vp_2' do
        expect(Adjuster.all_subordinates(vp_2.adjuster_id)).to contain_exactly(sub_vp_2_1.adjuster_id,
                                                                               sub_vp_2_2.adjuster_id,
                                                                               sub_vp_2_3.adjuster_id,
                                                                               adjuster_2_1_1.adjuster_id,
                                                                               adjuster_2_1_2.adjuster_id,
                                                                               adjuster_2_1_3.adjuster_id,
                                                                               adjuster_2_2_1.adjuster_id,
                                                                               adjuster_2_2_2.adjuster_id,
                                                                               adjuster_2_2_3.adjuster_id,
                                                                               adjuster_2_3_1.adjuster_id,
                                                                               adjuster_2_3_2.adjuster_id,
                                                                               adjuster_2_3_3.adjuster_id
                                                                               )
      end

      it 'returns all subordinates for vp_3' do
        expect(Adjuster.all_subordinates(vp_3.adjuster_id)).to contain_exactly(sub_vp_3_1.adjuster_id,
                                                                               sub_vp_3_2.adjuster_id,
                                                                               sub_vp_3_3.adjuster_id,
                                                                               adjuster_3_1_1.adjuster_id,
                                                                               adjuster_3_1_2.adjuster_id,
                                                                               adjuster_3_1_3.adjuster_id,
                                                                               adjuster_3_2_1.adjuster_id,
                                                                               adjuster_3_2_2.adjuster_id,
                                                                               adjuster_3_2_3.adjuster_id,
                                                                               adjuster_3_3_1.adjuster_id,
                                                                               adjuster_3_3_2.adjuster_id,
                                                                               adjuster_3_3_3.adjuster_id
                                                                               )
      end

      it 'returns all subordinates for the_king' do
        expect(Adjuster.all_subordinates(the_king.adjuster_id)).to(
          match_array(Adjuster.where.not(adjuster_id: the_king.adjuster_id).map(&:adjuster_id))
        )
      end
    end
    
  end

  context 'instance methods' do
    let(:jaime) { build(:adjuster, name: 'Jaime Lannister') }
    let(:hodor) { build(:adjuster, name: 'Hodor') }

    context '#name_first' do
      it 'returns the first token in the adjuster\'s name, split on whitespace' do
        expect(jaime.name_first).to eql('Jaime')
      end

      it 'returns the entire name if the name is a single token' do
        expect(hodor.name_first).to eql(hodor.name)
      end
    end

    context '#name_last' do
      it 'returns the last token in the adjuster\'s name, split on whitespace' do
        expect(jaime.name_last).to eql('Lannister')
      end

      it 'returns nil if the name is a single token' do
        expect(hodor.name_last).to be_nil
      end
    end
  end
end
