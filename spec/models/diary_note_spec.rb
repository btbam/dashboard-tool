require 'spec_helper'

RSpec.describe DiaryNote, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it 'can be initialized' do
    expect(DiaryNote.new).to be_a(DiaryNote)
  end

  it 'has a valid factory' do
    expect(create(:diary_note)).to be_valid
  end
end
