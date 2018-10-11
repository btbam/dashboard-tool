# role = Role.create(name: 'test')
# user = User.create(email: 'test@dashboard.com', name_first: 'test', name_last: 'test', dashboard_lan_id: 'test', login: 'test', dashboard_adjuster_id: 'test', roles: [role])
# feat = Feature.last
# cf = ClosedFeature.create(user_id: user.id, dashboard_compound_key: feat.dashboard_compound_key)
# fb = Feedback.create(user_id: user.id, feature_id: feat.dashboard_compound_key)
# dnt = DiaryNoteType.create(name: 'test')
# dn = DiaryNote.create(user_id: user.id, dashboard_compound_key: feat.dashboard_compound_key, diary: 'test')
# dndnt = DiaryNotesDiaryNoteType.create(diary_note_id: dn.id, diary_note_type_id: dnt.id)
# fd = FeatureDate.create(dashboard_compound_key: feat.dashboard_compound_key, due: Time.now - 14.months, role_name: 'test')
# hc = HiddenColumn.create(column_name: 'test')
# uhc = UserHiddenColumn.create(hidden_column_id: hc.id, user_id: user.id)

# # in another tab
# SYNC=true rake sync:old_to_new_oracle:all
# # Objects other than those listed below should no longer exist

# role.delete
# dnt.delete
# hc.delete

# role = DataSync::Role.create(name: 'test')
# user = DataSync::User.create(email: 'test@dashboard.com', name_first: 'test', name_last: 'test', dashboard_lan_id: 'test', login: 'test', dashboard_adjuster_id: 'test', roles: [role])
# feat = DataSync::Feature.last
# cf = DataSync::ClosedFeature.create(user_id: user.id, dashboard_compound_key: feat.dashboard_compound_key)
# fb = DataSync::Feedback.create(user_id: user.id, feature_id: feat.dashboard_compound_key)
# dnt = DataSync::DiaryNoteType.create(name: 'test')
# dn = DataSync::DiaryNote.create(user_id: user.id, dashboard_compound_key: feat.dashboard_compound_key, diary: 'test')
# dndnt = DataSync::DiaryNotesDiaryNoteType.create(diary_note_id: dn.id, diary_note_type_id: dnt.id)
# fd = DataSync::FeatureDate.create(dashboard_compound_key: feat.dashboard_compound_key, due: Time.now - 14.months, role_name: 'test')
# hc = DataSync::HiddenColumn.create(column_name: 'test')
# uhc = DataSync::UserHiddenColumn.create(hidden_column_id: hc.id, user_id: user.id)

# # in another tab
# SYNC=true rake sync:old_to_new_oracle:all
# # All objects should be copied to new DB

# role.delete
# dnt.delete
# hc.delete

$stdout.sync = true

namespace :sync do
  namespace :old_to_new_oracle do
    def merge_record(source, dest, delete_keys = [])
      attrs = source.attributes
      attrs.delete("id")
      delete_keys.each do |key|
        attrs.delete(key)
      end
      dest.attributes = attrs
      dest
    end

    desc 'sync all data from Old Oracle to New Oracle'
    task :all => [:environment] do |t, args|
      Rake::Task["sync:old_to_new_oracle:roles"].execute
      Rake::Task["sync:old_to_new_oracle:users"].execute
      Rake::Task["sync:old_to_new_oracle:role_permissions"].execute
      Rake::Task["sync:old_to_new_oracle:closed_features"].execute
      Rake::Task["sync:old_to_new_oracle:feedbacks"].execute
      Rake::Task["sync:old_to_new_oracle:diary_note_types"].execute
      Rake::Task["sync:old_to_new_oracle:diary_notes"].execute
      Rake::Task["sync:old_to_new_oracle:diary_notes_diary_note_types"].execute
      Rake::Task["sync:old_to_new_oracle:feature_dates"].execute
      Rake::Task["sync:old_to_new_oracle:hidden_columns"].execute
      Rake::Task["sync:old_to_new_oracle:user_hidden_columns"].execute
    end

    desc 'sync Role from old to new Oracle'
    task :roles => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing roles..."
      DataSync::Role.all.each do |role|
        new_role = Role.find_or_initialize_by(name: role.name)
        new_role = merge_record(role, new_role, ['name'])
        puts "saving #{new_role.name}"
        new_role.save if ENV['SYNC']
      end
      puts "Finished syncing roles"
      puts "#{Role.count} :: #{DataSync::Role.count}"
    end

    desc 'sync HiddenColumn from old to new Oracle'
    task :hidden_columns => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing hidden_columns..."
      DataSync::HiddenColumn.all.each do |hidden_column|
        new_hidden_column = HiddenColumn.find_or_initialize_by(column_name: hidden_column.column_name)
        new_hidden_column = merge_record(hidden_column, new_hidden_column, ['column_name'])
        puts "saving #{new_hidden_column.column_name}"
        new_hidden_column.save if ENV['SYNC']
      end
      puts "Finished syncing hidden_columns"
      puts "#{HiddenColumn.count} :: #{DataSync::HiddenColumn.count}"
    end

    desc 'sync DiaryNoteType from old to new Oracle'
    task :diary_note_types => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing diary_note_types..."
      DataSync::DiaryNoteType.all.each do |diary_note_type|
        new_diary_note_type = DiaryNoteType.find_or_initialize_by(name: diary_note_type.name)
        new_diary_note_type = merge_record(diary_note_type, new_diary_note_type, ['name'])
        puts "saving #{new_diary_note_type.name}"
        new_diary_note_type.save if ENV['SYNC']
      end
      puts "Finished syncing diary_note_types"
      puts "#{DiaryNoteType.count} :: #{DataSync::DiaryNoteType.count}"
    end

    desc 'sync User from Old Oracle to New Oracle'
    task :users => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing users"
      puts "Started removing users from New Oracle that don't exist in Old Oracle"
      User.all.each do |user|
        if !DataSync::User.find_by(email: user.email)
          puts "deleting #{user.email}"
          user.delete if ENV['SYNC']
        end
      end
      puts "Finished removing users from New Oracle that don't exist in Old Oracle"
      puts "Started syncing users..."
      DataSync::User.all.each do |user|
        existing_user = User.find_or_initialize_by(email: user.email)
        existing_user = merge_record(user, existing_user, ['email'])
        puts "saving #{existing_user.email}"
        existing_user.save(validate: false) if ENV['SYNC']
      end
      puts "Finished syncing users"
      puts "#{User.count} :: #{DataSync::User.count}"
    end

    desc 'sync RolePermission from Old Oracle to New Oracle'
    task :role_permissions => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing role_permissions"
      puts "Started removing role_permissions from New Oracle that don't exist in Old Oracle"
      RolePermission.all.each do |role_permission|
        pg_user = DataSync::User.find_by(email: role_permission.user.try(:email))
        pg_role = DataSync::Role.find_by(name: role_permission.role.try(:name))
        if !pg_user || !pg_role || !DataSync::RolePermission.find_by(user_id: pg_user.id, role_id: pg_role.id)
          puts "deleting #{role_permission.user_id} #{role_permission.role_id}"
          role_permission.delete if ENV['SYNC']
        end
      end
      puts "Finished removing role_permissions from New Oracle that don't exist in Old Oracle"
      puts "Started syncing role_permissions..."
      error_count = 0
      DataSync::RolePermission.all.each do |role_permission|
        user = User.find_by(email: role_permission.user.try(:email))
        role = Role.find_by(name: role_permission.role.try(:name))
        if user && role
          existing_role_permission = RolePermission.find_or_initialize_by(user_id: user.id, role_id: role.id)
          existing_role_permission = merge_record(role_permission, existing_role_permission, ['user_id', 'role_id'])
          puts "saving #{existing_role_permission.user_id} #{existing_role_permission.role_id}"
          existing_role_permission.save if ENV['SYNC']
        else
          error_count += 1
        end
      end
      puts "Finished syncing role_permissions"
      puts "#{RolePermission.count} :: #{DataSync::RolePermission.count - error_count}"
    end

    desc 'sync UserHiddenColumn from Old Oracle to New Oracle'
    task :user_hidden_columns => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing user_hidden_columns"
      puts "Started removing user_hidden_columns from New Oracle that don't exist in Old Oracle"
      UserHiddenColumn.all.each do |user_hidden_column|
        old_user = DataSync::User.find_by(email: user_hidden_column.user.try(:email))
        old_hidden_column = DataSync::HiddenColumn.find_by(column_name: user_hidden_column.hidden_column.try(:column_name))
        if !old_user || !old_hidden_column || !DataSync::UserHiddenColumn.find_by(user_id: old_user.id, hidden_column_id: old_hidden_column.id)
          puts "deleting #{user_hidden_column.user_id} #{user_hidden_column.hidden_column_id}"
          user_hidden_column.delete if ENV['SYNC']
        end
      end
      puts "Finished removing user_hidden_columns from New Oracle that don't exist in Old Oracle"
      puts "Started syncing user_hidden_columns..."
      error_count = 0
      DataSync::UserHiddenColumn.all.each do |user_hidden_column|
        user = User.find_by(email: user_hidden_column.user.try(:email))
        hidden_column = HiddenColumn.find_by(column_name: user_hidden_column.hidden_column.column_name)
        if user && hidden_column
          existing_user_hidden_column = UserHiddenColumn.find_or_initialize_by(user_id: user.id, hidden_column_id: hidden_column.id)
          existing_user_hidden_column = merge_record(user_hidden_column, existing_user_hidden_column, ['user_id', 'hidden_column_id'])
          puts "saving #{existing_user_hidden_column.user_id} #{existing_user_hidden_column.hidden_column_id}"
          existing_user_hidden_column.save if ENV['SYNC']
        else
          error_count += 1
        end
      end
      puts "Finished syncing user_hidden_columns"
      puts "#{UserHiddenColumn.count} :: #{DataSync::UserHiddenColumn.count - error_count}"
    end

    desc 'sync DiaryNotesDiaryNoteTypes from Old Oracle to New Oracle'
    task :diary_notes_diary_note_types => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing diary_notes_diary_note_types"
      puts "Started removing diary_notes_diary_note_types from New Oracle that don't exist in Old Oracle..."
      DiaryNotesDiaryNoteType.all.each do |diary_notes_diary_note_type|
        old_diary_note = DiaryNote.where(dashboard_compound_key: diary_notes_diary_note_type.diary_note.try(:dashboard_compound_key),
                                         user_id: diary_notes_diary_note_type.diary_note.try(:user_id),
                                         created_at: diary_notes_diary_note_type.diary_note.try(:created_at))
                                  .where("to_char( diary_notes.diary) = ?", diary_notes_diary_note_type.diary_note.try(:diary)).first
        old_diary_note_type = DataSync::DiaryNoteType.find_by(name: diary_notes_diary_note_type.diary_note_type.try(:name))
        if !old_diary_note || !old_diary_note_type || !DataSync::DiaryNotesDiaryNoteType.find_by(diary_note_id: old_diary_note.id, diary_note_type_id: old_diary_note_type.id)
          puts "deleting #{diary_notes_diary_note_type.diary_note_id} #{diary_notes_diary_note_type.diary_note_type_id}"
          diary_notes_diary_note_type.delete if ENV['SYNC']
        end
      end
      puts "Finished removing diary_notes_diary_note_types from New Oracle that don't exist in Old Oracle"
      puts "Started syncing diary_notes_diary_note_types..."
      error_count = 0
      DataSync::DiaryNotesDiaryNoteType.all.each do |diary_notes_diary_note_type|
        diary_note = DiaryNote.where(dashboard_compound_key: diary_notes_diary_note_type.diary_note.try(:dashboard_compound_key),
                                     user_id: diary_notes_diary_note_type.diary_note.try(:user_id),
                                     created_at: diary_notes_diary_note_type.diary_note.try(:created_at))
                              .where("to_char( diary_notes.diary) = ?", diary_notes_diary_note_type.diary_note.try(:diary)).first
        diary_note_type = DiaryNoteType.find_by(name: diary_notes_diary_note_type.diary_note_type.try(:name))
        if diary_note && diary_note_type
          existing_diary_notes_diary_note_type = DiaryNotesDiaryNoteType.find_or_initialize_by(diary_note_id: diary_note.id, diary_note_type_id: diary_note_type.id)
          existing_diary_notes_diary_note_type = merge_record(diary_notes_diary_note_type, existing_diary_notes_diary_note_type, ['diary_note_id', 'diary_note_type_id'])
          puts "saving #{existing_diary_notes_diary_note_type.diary_note_id} #{existing_diary_notes_diary_note_type.diary_note_type_id}"
          existing_diary_notes_diary_note_type.save if ENV['SYNC']
        else
          error_count += 1
        end
      end
      puts "Finished syncing diary_notes_diary_note_types"
      puts "#{DiaryNotesDiaryNoteType.count} :: #{DataSync::DiaryNotesDiaryNoteType.count - error_count}"
    end

    desc 'sync ClosedFeature from Old Oracle to New Oracle'
    task :closed_features => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing closed_features"
      puts "Started removing closed_features from New Oracle that don't exist in Old Oracle..."
      ClosedFeature.all.each do |closed_feature|
        pg_user = DataSync::User.find_by(email: closed_feature.user.try(:email))
        if !pg_user || !DataSync::ClosedFeature.find_by(dashboard_compound_key: closed_feature.dashboard_compound_key, user_id: pg_user.id)
          puts "deleting #{closed_feature.dashboard_compound_key}"
          closed_feature.delete if ENV['SYNC']
        end
      end
      puts "Finished removing closed_features from New Oracle that don't exist in Old Oracle"
      puts "Started syncing closed_features..."
      DataSync::ClosedFeature.all.each do |closed_feature|
        user = User.find_by(email: closed_feature.user.try(:email))
        if user
          existing_closed_feature = ClosedFeature.find_or_initialize_by(dashboard_compound_key: closed_feature.dashboard_compound_key, user_id: user.id)
          existing_closed_feature = merge_record(closed_feature, existing_closed_feature, ['dashboard_compound_key', 'user_id'])
          puts "saving #{existing_closed_feature.dashboard_compound_key}"
          existing_closed_feature.save if ENV['SYNC']
        end
      end
      puts "Finished syncing closed_feature"
      puts "#{ClosedFeature.count} :: #{DataSync::ClosedFeature.count}"
    end

    desc 'sync FeatureDates from Old Oracle to New Oracle'
    task :feature_dates => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing feature_dates"
      puts "Started removing feature_dates from New Oracle that don't exist in Old Oracle..."
      FeatureDate.all.each do |feature_date|
        old_feature = Feature.find_by(dashboard_compound_key: feature_date.try(:dashboard_compound_key))
        if !old_feature || !DataSync::FeatureDate.find_by(dashboard_compound_key: feature_date.dashboard_compound_key, role_name: feature_date.role_name)
          puts "deleting #{feature_date.dashboard_compound_key}"
          feature_date.delete if ENV['SYNC']
        end
      end
      puts "Finished removing feature_dates from New Oracle that don't exist in Old Oracle"
      puts "Started syncing feature_dates..."
      error_count = 0
      DataSync::FeatureDate.all.each do |feature_date|
        feature = Feature.find_by(dashboard_compound_key: feature_date.try(:dashboard_compound_key))
        if feature
          existing_feature_date = FeatureDate.find_or_initialize_by(dashboard_compound_key: feature_date.dashboard_compound_key, role_name: feature_date.role_name)
          existing_feature_date = merge_record(feature_date, existing_feature_date, ['dashboard_compound_key', 'role_name'])
          puts "saving #{existing_feature_date.dashboard_compound_key}"
          existing_feature_date.save if ENV['SYNC']
        else
          error_count += 1
        end
      end
      puts "Finished syncing feature_date"
      puts "#{FeatureDate.count} :: #{DataSync::FeatureDate.count - error_count}"
    end

    desc 'sync DiaryNote from Old Oracle to New Oracle'
    task :diary_notes => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing diary_notes"
      puts "Started removing diary_notes from New Oracle that don't exist in Old Oracle..."
      DiaryNote.all.each do |diary_note|
        old_user = DataSync::User.find_by(email: diary_note.user.try(:email))
        old_feature = Feature.find_by(dashboard_compound_key: diary_note.feature.try(:dashboard_compound_key))
        if !old_user || !old_feature || !DataSync::DiaryNote.where(user_id: old_user.id, dashboard_compound_key: old_feature.dashboard_compound_key, created_at: diary_note.created_at).where("to_char( diary_notes.diary) = ?", diary_note.diary).first
          puts "deleting #{diary_note.user_id} #{diary_note.dashboard_compound_key}"
          diary_note.delete if ENV['SYNC']
        end
      end
      puts "Finished removing diary_notes from New Oracle that don't exist in Old Oracle"
      puts "Started syncing diary_notes..."
      error_count = 0
      DataSync::DiaryNote.all.each do |diary_note|
        user = User.find_by(email: diary_note.user.try(:email))
        feature = Feature.find_by(dashboard_compound_key: diary_note.feature.try(:dashboard_compound_key))
        if user && feature
          existing_diary_note = DiaryNote.where(user_id: user.id, dashboard_compound_key: feature.dashboard_compound_key, created_at: diary_note.created_at).where("to_char( diary_notes.diary) = ?", diary_note.diary).first
          existing_diary_note = DiaryNote.new(user_id: user.id, dashboard_compound_key: feature.dashboard_compound_key, created_at: diary_note.created_at, diary: diary_note.diary) if !existing_diary_note
          existing_diary_note = merge_record(diary_note, existing_diary_note, ['user_id', 'dashboard_compound_key', 'created_at', 'diary'])
          puts "saving #{existing_diary_note.user_id} #{existing_diary_note.dashboard_compound_key}"
          existing_diary_note.save if ENV['SYNC']
        else
          error_count += 1
        end
      end
      puts "Finished syncing diary_notes"
      puts "#{DiaryNote.count} :: #{DataSync::DiaryNote.count - error_count}"
    end

    desc 'sync Feedback from Old Oracle to New Oracle'
    task :feedbacks => [:environment] do |t, args|
      Rails.logger = Logger.new(STDOUT)
      puts "Started syncing feedbacks"
      puts "Started removing feedbacks from New Oracle that don't exist in Old Oracle"
      Feedback.all.each do |feedback|
        pg_user = DataSync::User.find_by(email: feedback.user.try(:email))
        if !pg_user || !DataSync::Feedback.find_by(feature_id: feedback.feature_id, user_id: pg_user.id)
          puts "deleting #{feedback.feature_id}"
          feedback.delete if ENV['SYNC']
        end
      end
      puts "Finished removing feedbacks from New Oracle that don't exist in Old Oracle"
      puts "Started syncing feedbacks..."
      DataSync::Feedback.all.each do |feedback|
        user = User.find_by(email: feedback.user.try(:email))
        if user
          existing_feedback = Feedback.find_or_initialize_by(feature_id: feedback.feature_id, user_id: user.id)
          existing_feedback = merge_record(feedback, existing_feedback, ['feature_id', 'user_id'])
          puts "saving #{existing_feedback.feature_id}"
          existing_feedback.save if ENV['SYNC']
        end
      end
      puts "Finished syncing feedback"
      puts "#{Feedback.count} :: #{DataSync::Feedback.count}"
    end
  end
end
