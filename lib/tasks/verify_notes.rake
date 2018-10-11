$stdout.sync = true

namespace :verify do
  desc 'import/update users using a csv'
  task :notes, [:compound_or_claim_no] => [:environment] do |_t, args|
    if args.compound_or_claim_no.include?('US') && args.compound_or_claim_no.split('-').size == 2
      # Claim
      ids = args.compound_or_claim_no.split('-')
      feature = Feature.where(claim_id: ids[0], feature_id: ids[1]).first
      fail "\n\nFeature Not Found\n\n" unless feature
      md = feature.notes.order(dashboard_database_unique_id: :desc).limit(1).first
      puts 'querying claim'
      # Claim notes aren't distinguished by feature id
      oc = OracleClaimNote.where(claim_no: ids[0]).order(etl_row_id: :desc).limit(1).first
      puts 'done querying claim'
      puts "Dashboard Most Recent Note:\nClaim ID: #{args.compound_or_claim_no}\ndashboard_created_at: #{md.dashboard_created_at}\ndashboard_created_at: #{md.created_at}\n#{md.message}\n"
      puts "\nClaim Most Recent Note:\n#{oc.xml_message_messagetxt_trunc}\nbusiness_create_ts: #{oc.business_create_ts}"
      dups = Feature.select('dashboard_database_unique_id, count(*)').group(:dashboard_database_unique_id).having('count(*) > 1').where(claim_id: ids[0], feature_id: ids[1]).pluck(:dashboard_database_unique_id)
      unless dups.blank?
        fail "\n\nTHERE ARE DUPLICATE FEATURES FOR dashboard_database_unique_id\n#{dups.inspect}\n\n"
      end
      unprocessed_notes = Note.where(dashboard_claim_id: md.dashboard_claim_id).where(processed: false)
      unless unprocessed_notes.blank?
        fail "\n\nTHERE ARE UNPROCESSED NOTES FOR THIS CLAIM\n\n"
      end
    elsif args.compound_or_claim_no.split('-').size == 3
      # ECSO
      ids = args.compound_or_claim_no.split('-')
      feature = Feature.where(dashboard_compound_key: args.compound_or_claim_no).first
      fail "\n\nFeature Not Found\n\n" unless feature
      md = feature.notes.order(dashboard_database_unique_id: :desc).limit(1).first
      puts 'querying ecso'
      ecso = OracleECSONote.where(application_key: ids[0] + '-' + ids[1]).where(note_sgmt_no: ids[2]).order(etl_row_id: :desc).limit(1).first
      puts 'done querying ecso'
      puts "Dashboard Most Recent Note:\nClaim ID: #{args.compound_or_claim_no}\ndashboard_created_at: #{md.dashboard_created_at}\ndashboard_created_at: #{md.created_at}\n#{md.message}\n"
      puts "\n\nECSO Most Recent Note:\n#{ecso.note_sgmt_txt}\nupdate_ts: #{ecso.update_ts}"
      dups = Feature.select('dashboard_database_unique_id, count(*)').group(:dashboard_database_unique_id).having('count(*) > 1').where(dashboard_compound_key: args.compound_or_claim_no).pluck(:dashboard_database_unique_id)
      unless dups.blank?
        fail "\n\nTHERE ARE DUPLICATE FEATURES FOR dashboard_database_unique_id\n#{dups.inspect}\n\n"
      end
      unprocessed_notes = Note.where(dashboard_claim_id: md.dashboard_claim_id).where(processed: false)
      unless unprocessed_notes.blank?
        fail "\n\nTHERE ARE UNPROCESSED NOTES FOR THIS CLAIM\n\n"
      end
    else
      # I don't know what you gave me
      fail "\n\nInvalid Claim ID\nPlease enter Claim Claim ID like Claim ID: 9211593760US-1\nPlease enter ECSO Claim ID like Dashboard Compound Key: 684-472492-1\n\n"
    end
  end
end
