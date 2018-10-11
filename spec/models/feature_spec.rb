require 'spec_helper'

describe Feature do
  it 'can be initialized' do
    expect(Feature.new).to be_a(Feature)
  end

  it 'has a valid factory' do
    expect(create(:feature)).to be_valid
  end

  context 'validations' do
    it { should validate_presence_of :branch_id }
    it { should validate_presence_of :case_id }
    it { should validate_presence_of :current_adjuster }
    it { should validate_presence_of :claim_status }
    it { should validate_presence_of :dashboard_compound_key }
    it { should validate_presence_of :claim_id }
    it { should validate_uniqueness_of(:claim_id).scoped_to(:claims_system, :feature_id) }
    it { should validate_uniqueness_of(:dashboard_database_unique_id) }
    it { should validate_uniqueness_of(:dashboard_compound_key) }
    it { should validate_inclusion_of(:claim_status).in_array(%w(V U M C B N O S)) }
    it { should_not validate_presence_of :dashboard_type_id }
    it { should_not validate_presence_of :dashboard_unique_feature_id }
  end

  context 'associations' do
    it { should belong_to :adjuster }
    it { should belong_to :case }
    it { should have_one(:policy).through(:case) }
    it { should have_many :notes }
    it { should have_many :financials }
    it { should have_many :dashboard_model_values }
    it { should have_and_belong_to_many :dashboard_models }
  end

  context 'scopes' do
    context '::open and ::closed' do
      let!(:feature_o) { create(:feature, claim_status: 'O') }
      let!(:feature_s) { create(:feature, claim_status: 'S') }
      let!(:feature_n) { create(:feature, claim_status: 'N') }

      context '::open' do
        let(:features) { Feature.open }

        it 'includes only records with a claim_status of "O" or "S"' do
          expect(features).to include(feature_o)
          expect(features).to include(feature_s)
          expect(features).to_not include(feature_n)
        end
      end

      context '::closed' do
        let(:features) { Feature.closed }

        it 'includes records with a claim_status other than "O" or "S"' do
          expect(features).to_not include(feature_o)
          expect(features).to_not include(feature_s)
          expect(features).to include(feature_n)
        end
      end
    end

    context '::with_created_date' do
      let!(:with_date) { create :feature, feature_created: 1.year.ago }
      let!(:without_date) { create :feature, feature_created: nil }
      let(:features) { Feature.with_created_date }

      it 'includes records with a feature_created timestamp' do
        expect(features).to include(with_date)
      end

      it 'does not include records with no feature_created timestamp' do
        expect(features).to_not include(without_date)
      end
    end

    context '::claims_system' do
      let!(:ecso_feature) { create :feature, claims_system: :ecso }
      let!(:oc_feature) { create :feature, claims_system: :one_claim }

      it 'includes features associated with the specified claims_system by enum' do
        expect(Feature.claims_system(:ecso)).to include(ecso_feature)
      end

      it 'includes features associated with the specified claims_system by id' do
        expect(Feature.claims_system(0)).to include(ecso_feature)
      end

      it 'excludes features that are not associated with the specified claims_system by enum' do
        expect(Feature.claims_system(:ecso)).to_not include(oc_feature)
      end

      it 'excludes features that are not associated with the specified claims_system by id' do
        expect(Feature.claims_system(0)).to_not include(oc_feature)
      end
    end

    context '::claim_id' do
      let!(:foo_feature) { create :feature, claim_id: 'foo' }
      let!(:bar_feature) { create :feature, claim_id: 'bar' }
      let(:features) { Feature.claim_id('foo') }

      it 'includes features matching the specified claim_id' do
        expect(features).to include(foo_feature)
      end

      it 'excludes features not matching the specified claim_id' do
        expect(features).to_not include(bar_feature)
      end
    end

    context '::current_adjuster' do
      let!(:adjuster_1) { create(:adjuster) }
      let!(:adjuster_2) { create(:adjuster) }
      let!(:feature_1) { create(:feature, current_adjuster: adjuster_1.adjuster_id) }
      let!(:feature_2) { create(:feature, current_adjuster: adjuster_2.adjuster_id) }

      it 'includes records that have an adjuster_id matching current_adjuster' do
        expect(Feature.current_adjuster(adjuster_1.adjuster_id)).to include(feature_1)
      end

      it 'includes records that belong to the adjuster matching current_adjuster' do
        expect(Feature.current_adjuster(adjuster_1)).to include(feature_1)
      end

      it 'excludes records that belong to a different adjuster when referenced by id' do
        expect(Feature.current_adjuster(adjuster_1.adjuster_id)).to_not include(feature_2)
      end

      it 'excludes records that belong to a different adjuster when referenced by adjuster' do
        expect(Feature.current_adjuster(adjuster_1)).to_not include(feature_2)
      end
    end

    context '::for_api' do
      # this isn't ideal, but it isn't worth the time to test it properly at the moment
      # TODO: figure out how to test this properly
      it 'doesn\'t raise an error' do
        expect { Feature.for_api }.to_not raise_error
      end
    end
  end

  context 'instance methods' do
    context '#total_outstanding' do
      let(:feature_1) { build(:feature, indemnity_outstanding: 1, medical_outstanding: 3, legal_outstanding: 5) }
      let(:feature_2) { build(:feature, indemnity_outstanding: 1, medical_outstanding: nil, legal_outstanding: 5) }

      it 'returns the sum of #indemnity_outstanding, #medical_outstanding, and #legal_outstanding' do
        expect(feature_1.total_outstanding).to eql(9.0)
      end

      it 'counts nil as 0' do
        expect(feature_2.total_outstanding).to eql(6.0)
      end
    end

    context '#last_note_datetime' do
      let!(:feature_with_notes) { create(:feature_with_notes) }
      let!(:feature_without_notes) { create(:feature) }

      it 'returns the dashboard_updated_at timestamp of the most recent note if any exist' do
        expect(feature_with_notes.last_note_datetime).to eql(Note.pluck(:dashboard_updated_at).sort.last)
      end

      it 'returns nil if no notes exist' do
        expect(feature_without_notes.last_note_datetime).to eql(nil)
      end
    end

    context '#datetime_humanize' do
      it 'formats the datetime correctly' do
        expect(Feature.new.datetime_humanize(Time.zone.parse('17-4-2015'))).to eql('4/17/15')
      end
    end

    context '#feature_created_humanize' do
      it 'humanizes the feature_created timestamp' do
        date = Time.zone.parse('17-4-2015')
        fe = Feature.new(feature_created: date)
        expect(fe).to receive(:datetime_humanize).with(date).and_return(:foo)
        expect(fe.feature_created_humanize).to eql(:foo)
      end
    end

    context '#claimant_name_humanize' do
      it 'attempts to call #titleize on #claimant_name' do
        fe = Feature.new
        name = 'foo'
        expect(fe).to receive(:claimant_name).and_return(name)
        expect(name).to receive(:try).with(:titleize).and_return('bar')
        expect(fe.claimant_name_humanize).to eql('bar')
      end
    end
  end
end
