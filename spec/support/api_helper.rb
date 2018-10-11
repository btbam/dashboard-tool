require 'spec_helper'

RSpec.shared_context 'api helper cleanup' do
  after { Grape::Endpoint.before_each nil }
end

RSpec.shared_context 'with valid logged-in user' do
  let!(:valid_user) { create(:user) }

  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:current_user).and_return(valid_user)
      allow(endpoint).to receive(:can?).and_return(true)
    end
  end
end

RSpec.shared_context 'logged in with privileges' do
  let!(:valid_user) { create(:user) }

  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:current_user).and_return(valid_user)
      allow(endpoint).to receive(:can?).and_return(true)
    end
  end

  include_context 'api helper cleanup'
end

RSpec.shared_context 'logged in without privileges' do
  let!(:valid_user) { create(:user) }

  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:current_user).and_return(valid_user)
      allow(endpoint).to receive(:can?).and_return(false)
    end
  end

  include_context 'api helper cleanup'
end

RSpec.shared_context 'with valid features and associations' do
  let!(:valid_user) { create(:user) }
  let!(:adjuster) { create(:adjuster, adjuster_id: valid_user.dashboard_adjuster_id) }
  let!(:policy) { create(:policy) }
  let!(:the_case) do
    create(:case,
           dashboard_policy_compound_key: policy.dashboard_compound_key,
           policy_number: policy.policy_number)
  end
  let!(:claim) do
    create(:feature,
           current_adjuster: adjuster.adjuster_id,
           branch_id: the_case.branch_id,
           case_id: the_case.case_number)
  end
  let!(:notes) do
    create_list(:note,
                5,
                dashboard_author_id: adjuster.adjuster_id,
                author: adjuster,
                dashboard_claim_id: claim.claim_id)
  end

  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:current_user).and_return(valid_user)
      allow(endpoint).to receive(:can?).and_return(true)
    end
  end

  include_context 'api helper cleanup'
end

def basic_auth
  { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(ENV['MONITORING_USER'],
                                                                                           ENV['MONITORING_PASS']) }
end
