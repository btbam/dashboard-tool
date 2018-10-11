$stdout.sync = true

namespace :sync do
  namespace :dump do
    desc 'dump all data from old oracle'
    task :all => [:environment] do |t, args|
      klasses = ['DataSync::Role', 'DataSync::User', 'DataSync::RolePermission', 'DataSync::ClosedFeature', 'DataSync::Feedback', 'DataSync::DiaryNoteType', 'DataSync::DiaryNote', 'DataSync::DiaryNotesDiaryNoteType', 'DataSync::FeatureDate', 'DataSync::HiddenColumn', 'DataSync::UserHiddenColumn',
                 'Role', 'User', 'RolePermission', 'ClosedFeature', 'Feedback', 'DiaryNoteType', 'DiaryNote', 'DiaryNotesDiaryNoteType', 'FeatureDate', 'HiddenColumn', 'UserHiddenColumn']
      klasses.each do |klass|
        klass.constantize.class_eval do
          def self.to_csv
            attributes = column_names
            CSV.open('./backups/'+name+'_'+Rails.env+'_dump.csv', 'w', headers: true) do |csv|
              csv << attributes

              all.each do |instance|
                csv << attributes.map{ |attr| instance.send(attr) }
              end
            end
          end
        end
      end

      klasses.each do |klass|
        klass.constantize.to_csv
      end
    end
  end
end
