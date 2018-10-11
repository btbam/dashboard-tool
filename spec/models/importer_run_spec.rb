require 'spec_helper'

describe ImporterRun do
  it 'can be initialized' do
    expect(ImporterRun.new).to be_a(ImporterRun)
  end

  it 'has a valid factory' do
    expect(create(:importer_run)).to be_valid
  end

  context 'scopes' do
    context '::recent' do
      let!(:new_import) { create(:importer_run, started_at: Time.zone.now - 20.hours) }
      let!(:old_import) { create(:importer_run, started_at: Time.zone.now - 30.hours) }
      let(:importer_runs) { ImporterRun.recent }

      it 'includes any that were started in the last 26 hours' do
        expect(importer_runs).to include(new_import)
      end

      it 'excludes any started more than 26 hours ago' do
        expect(importer_runs).to_not include(old_import)
      end
    end

    context '::successful' do
      let!(:with_errors) { create(:importer_run, error_trace: Faker::Lorem.sentence) }
      let!(:without_errors) { create(:importer_run) }
      let(:importer_runs) { ImporterRun.successful }

      it 'includes those that have no error trace' do
        expect(importer_runs).to include(without_errors)
      end

      it 'excludes those with an error trace' do
        expect(importer_runs).to_not include(with_errors)
      end
    end

    context '::productive' do
      let!(:productive_created) { create(:importer_run, records_created: 10, records_updated: 0) }
      let!(:productive_updated) { create(:importer_run, records_created: 0, records_updated: 10) }
      let!(:productive_both) { create(:importer_run, records_created: 10, records_updated: 10) }
      let!(:unproductive_with_single_update) { create(:importer_run, records_created: 0, records_updated: 1) }
      let!(:unproductive_completely) { create(:importer_run, records_created: 0, records_updated: 0) }
      let(:importer_runs) { ImporterRun.productive }

      it 'includes those that created records' do
        expect(importer_runs).to include(productive_created)
      end

      it 'includes those that updated more than 1 record' do
        expect(importer_runs).to include(productive_updated)
      end

      it 'includes those that both created records and updated multiple records' do
        expect(importer_runs).to include(productive_both)
      end

      it 'excludes those that created 0 and only updated exactly 1 record' do
        expect(importer_runs).to_not include(unproductive_with_single_update)
      end

      it 'excludes those that neither created nor updated records' do
        expect(importer_runs).to_not include(unproductive_completely)
      end
    end

    context '::source_model' do
      let!(:note_import) { create(:importer_run, source_model: 'OracleClaimNote') }
      let!(:adjuster_import) { create(:importer_run, source_model: 'OracleReferenceAdjuster') }

      it 'includes any that have the correct single source model, specified as a string' do
        expect(ImporterRun.source_model('OracleClaimNote')).to include(note_import)
      end

      it 'includes all that are included in the source models specified as strings' do
        importer_runs = ImporterRun.source_model('OracleClaimNote', 'OracleReferenceAdjuster')
        expect(importer_runs).to include(note_import)
        expect(importer_runs).to include(adjuster_import)
      end

      it 'excludes any that are not specified' do
        expect(ImporterRun.source_model('OracleNote')).to_not include(adjuster_import)
      end
    end

    context '::destination_model' do
      let!(:note_import) { create(:importer_run, destination_model: 'Note') }
      let!(:adjuster_import) { create(:importer_run, destination_model: 'Adjuster') }

      it 'includes any that have the correct single destination model, specified as a string' do
        expect(ImporterRun.destination_model('Note')).to include(note_import)
      end

      it 'includes any that have the correct single destination model, specified as a class' do
        expect(ImporterRun.destination_model(Note)).to include(note_import)
      end

      it 'includes all that are included in the destination models specified as strings' do
        importer_runs = ImporterRun.destination_model('Note', 'Adjuster')
        expect(importer_runs).to include(note_import)
        expect(importer_runs).to include(adjuster_import)
      end

      it 'includes all that are included in the destination models specified as classes' do
        importer_runs = ImporterRun.destination_model(Note, Adjuster)
        expect(importer_runs).to include(note_import)
        expect(importer_runs).to include(adjuster_import)
      end

      it 'includes all that are included in the destination models specified as a single array argument rather than multiple arguments' do
        importer_runs = ImporterRun.destination_model([Note, Adjuster])
        expect(importer_runs).to include(note_import)
        expect(importer_runs).to include(adjuster_import)
      end

      it 'excludes any that are not specified' do
        expect(ImporterRun.destination_model('Note')).to_not include(adjuster_import)
      end
    end
  end

  context 'singleton methods' do
    context '::ok?' do
      it 'returns true if the success count is 9' do
        expect(ImporterRun).to receive(:success_count).and_return(9)
        expect(ImporterRun.ok?).to be true
      end

      it 'returns true if the success count is not 9' do
        expect(ImporterRun).to receive(:success_count).and_return(7)
        expect(ImporterRun.ok?).to be false
      end
    end

    context '::success_count' do
      let!(:unsuccessful) { create(:importer_run, error_trace: Faker::Lorem.sentence) }
      let!(:old_unsuccessful) do
        create(:importer_run,
               :not_recent,
               source_model: 'OracleReferenceAdjuster',
               destination_model: 'Adjuster')
      end
      let!(:new_successful_1) do
        create(:importer_run,
               :recent, source_model: 'OracleClaimNote',
               destination_model: 'Note')
      end
      let!(:new_successful_2) do
        create(:importer_run,
               :recent,
               source_model: 'OracleClaimNote',
               destination_model: 'Note')
      end
      let!(:new_successful_3) do
        create(:importer_run,
               :recent,
               source_model: 'OracleEcsoNote',
               destination_model: 'Note')
      end
      it 'returns a count of all unique recent and successful imports' do
        expect(ImporterRun.success_count).to eql(2)
      end
    end

    context '::last_update' do
      let(:last_completion_time) { Time.zone.today.beginning_of_day }
      let!(:case_import) do
        create(:importer_run,
               destination_model: 'Case',
               completed_at: last_completion_time)
      end
      let!(:feature_import) do
        create(:importer_run,
               destination_model: 'Feature',
               completed_at: last_completion_time - 1.hour)
      end
      let!(:adjuster_import) do
        create(:importer_run,
               destination_model: 'Adjuster',
               completed_at: last_completion_time + 1.hour)
      end
      let!(:unproductive_import) do
        create(:importer_run,
               :unproductive,
               destination_model: 'Policy',
               completed_at: last_completion_time + 2.hours)
      end
      it 'returns the completion time for the most recently completed successful and productive import of the specified models' do
        expect(ImporterRun.last_update).to eq(last_completion_time)
      end
    end
  end
end
