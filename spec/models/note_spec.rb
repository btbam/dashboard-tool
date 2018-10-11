require 'spec_helper'

describe Note do
  it 'can be initialized' do
    expect(Note.new).to be_a(Note)
  end

  it 'has a valid factory' do
    expect(create(:note)).to be_valid
  end

  context 'enum' do
    it { should define_enum_for(:claims_system).with([:ecso, :one_claim]) }
  end

  context 'validations' do
    it { should validate_presence_of :original_message }
    it { should validate_uniqueness_of(:dashboard_note_id).scoped_to(:claims_system, :segment_id) }
    it { should validate_presence_of :claims_system }
    it { should validate_presence_of :segment_id }
    it { should validate_uniqueness_of(:segment_id).scoped_to(:claims_system, :dashboard_note_id) }
  end

  context 'associations' do
    it { should belong_to :feature }
    it { should belong_to :author }
  end

  context 'scopes' do
    context '::displayable' do
      let!(:processed_first_segment) { create(:note) }
      let!(:processed_second_segment) { create(:note, segment_id: 2) }
      let!(:unprocessed_first_segment) { create(:note, processed: 0, segment_id: 1) }
      let(:notes) { Note.displayable }

      it 'includes processed notes with a #segment_id of 1' do
        expect(notes).to include(processed_first_segment)
      end

      it 'excludes processed notes with a #segment_id other than 1' do
        expect(notes).to_not include(processed_second_segment)
      end

      it 'excludes all unprocessed notes' do
        expect(notes).to_not include(unprocessed_first_segment)
      end
    end

    context '::processed and ::unprocessed' do
      let!(:processed) { create(:note) }
      let!(:unprocessed_false) { create(:note, processed: 0) }
      let!(:unprocessed_nil) { create(:note, processed: nil) }

      context '::processed' do
        let(:notes) { Note.processed }

        it 'includes notes with a #processed value of true' do
          expect(notes).to include(processed)
        end

        it 'excludes notes with a #processed value of false' do
          expect(notes).to_not include(unprocessed_false)
        end

        it 'excludes notes with a #processed value of nil' do
          expect(notes).to_not include(unprocessed_nil)
        end
      end

      context '::unprocessed' do
        let(:notes) { Note.unprocessed }

        it 'includes notes with a #processed value of nil' do
          expect(notes).to include(unprocessed_nil)
        end

        it 'includes notes with a #processed value of false' do
          expect(notes).to include(unprocessed_false)
        end

        it 'excludes notes with a #processed value of true' do
          expect(notes).to_not include(processed)
        end
      end
    end

    context '::ecso and ::claim' do
      let!(:ecso) { create(:note, claims_system: 0) }
      let!(:claim) { create(:note, claims_system: 1) }

      context '::ecso' do
        let(:notes) { Note.ecso }

        it 'includes notes with a #claims_system value of 0' do
          expect(notes).to include(ecso)
        end

        it 'excludes notes with a #claims_system value other than 0' do
          expect(notes).to_not include(claim)
        end
      end

      context '::claim' do
        let(:notes) { Note.claim }

        it 'includes notes with a #claims_system value of 1' do
          expect(notes).to include(claim)
        end

        it 'excludes notes with a #claims_system value other than 1' do
          expect(notes).to_not include(ecso)
        end
      end
    end
  end

  context 'instance methods' do
    context '#human_message' do
      let(:note) { Note.new(message: 'foo bar') }

      it 'should return the result of passing #message to #simple_format' do
        expect(note).to receive(:simple_format).with('foo bar').and_return('baz')
        expect(note.human_message).to eq('baz')
      end
    end
  end
end
