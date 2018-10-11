# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create([{name: "adjuster"}, {name: "manager"}, {name: "executive"}, {name: "admin"}])
HiddenColumn.create([
  {column_name: "due_date"},
  {column_name: "flags"},
  {column_name: "age"},
  {column_name: "adjuster"},
  {column_name: "state"},
  {column_name: "claimant"},
  {column_name: "insured"},
  {column_name: "total_reserve"},
  {column_name: "total_paid"},
  {column_name: "indem"},
  {column_name: "med"},
  {column_name: "legal"},
  {column_name: "entry"},
  {column_name: "litigation"},
  {column_name: "total_reserve"},
])
HiddenColumn.update_all(display: false);
HiddenColumn.where( :column_name => ['adjuster', 'due_date', 'flags', 'entry', 'age']).update_all(display: true)

# This can be removed after everyone runs it
total_column = HiddenColumn.find_by_column_name('total')
if total_column
  total_column.delete
end

# This can be removed after everyone runs it
d = DiaryNoteType.find_by(name: 'Follow up')
if d
  d.name = 'follow-up'
  d.save
end

diary_note_types = %w(diary email call follow-up)
diary_note_types.each do |type|
  dt = DiaryNoteType.where("lower(name) = :name", name: type).first_or_initialize
  dt.name = type
  dt.save
end
