class IndexDiaryNotes < ActiveRecord::Migration
  def change
    add_index :diary_notes, :updated_at
  end
end
