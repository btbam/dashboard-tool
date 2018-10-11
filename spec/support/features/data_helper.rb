require 'spec_helper'

module Features
  module DataHelper
    def cleanup_data
      Adjuster.delete_all
      Case.delete_all
      Policy.delete_all
      ModelScore.delete_all
      Note.delete_all
      Feature.delete_all
      User.delete_all
    end

    def create_case(feature)
      create(:case, {dashboard_compound_key: feature.dashboard_compound_key})
    end

    def create_fully_loaded_feature(params = {})
      feature = create(:feature_with_notes, params)
      current_case = create_case(feature)
      current_case.features << feature
      feature.case = current_case

      model_score = create(:model_score, :touch, { claim_id: feature.claim_id })
      feature.model_scores << model_score
      feature
    end

    def create_importer_runs
      last_completion_time = Time.zone.today.beginning_of_day
      create(:importer_run, completed_at: last_completion_time)
    end

    def create_context_switcher_data
      create_importer_runs
      user1 = create(:user, { name_first: 'Lisa', name_last: 'Loeb', roles: [ Role.find_by_name('admin') ] })
      create(:adjuster, { name: 'Lisa Loeb', adjuster_id: user1.dashboard_adjuster_id})
      create_fully_loaded_feature(current_adjuster: user1.dashboard_adjuster_id)

      user2 = create(:user, { name_first: 'Natalie', name_last: 'Imbruglia' })
      create(:adjuster, { name: 'Natalie Imbruglia', adjuster_id: user2.dashboard_adjuster_id})
      create_fully_loaded_feature(current_adjuster: user2.dashboard_adjuster_id)
      create_fully_loaded_feature(current_adjuster: user2.dashboard_adjuster_id)

      user3 = create(:user, { name_first: 'Natalie', name_last: 'Injustice' })
      create(:adjuster, { name: 'Natalie Injustice', adjuster_id: user3.dashboard_adjuster_id})
      create_fully_loaded_feature(current_adjuster: user3.dashboard_adjuster_id)
      create_fully_loaded_feature(current_adjuster: user3.dashboard_adjuster_id)
      create_fully_loaded_feature(current_adjuster: user3.dashboard_adjuster_id)

      sign_in(user1)
    end

    def create_last_note_graph_data
      create_importer_runs
      user = create_user
      feature1 = create(:feature, current_adjuster: user.dashboard_adjuster_id)
      feature2 = create(:feature, current_adjuster: user.dashboard_adjuster_id)
      feature3 = create(:feature, current_adjuster: user.dashboard_adjuster_id)
      feature4 = create(:feature, current_adjuster: user.dashboard_adjuster_id)
      feature5 = create(:feature, current_adjuster: user.dashboard_adjuster_id)

      case1 = create_case(feature1)
      case1.features << feature1
      feature1.case = case1

      case2 = create_case(feature2)
      case2.features << feature2
      feature2.case = case2

      case3 = create_case(feature3)
      case3.features << feature3
      feature3.case = case3

      case4 = create_case(feature4)
      case4.features << feature4
      feature4.case = case4

      case5 = create_case(feature5)
      case5.features << feature5
      feature5.case = case5

      create(:note, { dashboard_claim_id: feature1.claim_id, dashboard_updated_at: Date.today - 5.days })
      create(:note, { dashboard_claim_id: feature2.claim_id, dashboard_updated_at: Date.today - 50.days })
      create(:note, { dashboard_claim_id: feature3.claim_id, dashboard_updated_at: Date.today - 75.days })
      create(:note, { dashboard_claim_id: feature4.claim_id, dashboard_updated_at: Date.today - 100.days })
      create(:note, { dashboard_claim_id: feature5.claim_id, dashboard_updated_at: Date.today - 32.days })

      sign_in(user)
    end

    def create_text_filter_data
      create_importer_runs
      user = create_user

      # Feature 1
      feature1 = create(:feature, {
        current_adjuster: user.dashboard_adjuster_id,
        branch_id: 111,
        case_id: 222222,
        state: 'STATE_OR',
        claimant_name: 'Emilia Clarke',
      })
      policy1 = create(:policy, { insured_name: 'Natalie Portman' })
      case1 = create(:case, { dashboard_compound_key: feature1.dashboard_compound_key, policy: policy1 })
      case1.features << feature1
      feature1.case = case1
      model_score1 = create(:model_score, :touch, { claim_id: feature1.claim_id })
      feature1.model_scores << model_score1
      create(:note, { dashboard_claim_id: feature1.claim_id, message: 'NOTE TEXT 111-222222'})

      # Feature 2
      feature2 = create(:feature, {
        current_adjuster: user.dashboard_adjuster_id,
        branch_id: 333,
        case_id: 444444,
        state: 'STATE_CA',
        claimant_name: 'Scarlett Johannson',
      })
      policy2 = create(:policy, { insured_name: 'January Jones' })
      case2 = create(:case, { dashboard_compound_key: feature2.dashboard_compound_key, policy: policy2 })
      case2.features << feature2
      feature2.case = case2
      model_score2 = create(:model_score, :touch, { claim_id: feature2.claim_id })
      feature2.model_scores << model_score2
      create(:note, { dashboard_claim_id: feature2.claim_id, message: 'NOTE TEXT 333-444444'})

      # Feature 3
      feature3 = create(:feature, {
        current_adjuster: user.dashboard_adjuster_id,
        branch_id: 555,
        case_id: 666666,
        state: 'STATE_WA',
        claimant_name: 'Morena Baccarin',
      })
      policy3 = create(:policy, { insured_name: 'Eliza Dushku' })
      case3 = create(:case, { dashboard_compound_key: feature3.dashboard_compound_key, policy: policy3 })
      case3.features << feature3
      feature3.case = case3
      model_score3 = create(:model_score, :touch, { claim_id: feature3.claim_id })
      feature3.model_scores << model_score3
      create(:note, { dashboard_claim_id: feature3.claim_id, message: 'NOTE TEXT 555-666666'})

      create(:adjuster, { name: 'Jessica Alba', adjuster_id: user.dashboard_adjuster_id})

      sign_in(user)
      user
    end

    def create_user(params = {})
      return create(:user, params)
    end
  end
end
