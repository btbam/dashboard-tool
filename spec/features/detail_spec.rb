require 'spec_helper'

feature 'Detail', js: true do
  before do
    create_importer_runs
    user = create_user
    create_fully_loaded_feature(current_adjuster: user.dashboard_adjuster_id)
    sign_in(user)
  end

  after do
    cleanup_data
  end

  scenario 'Can close and reopen claim' do
    expect(page).to have_all_claims_count 1
    expect(page).to have_closed_claims_count 0
    page.click_sidebar_all_claims_link
    page.click_claim_list_row(1)
    page.click_close_claim_link
    expect(page).to have_closed_claims_count 1
    page.click_reopen_claim_link
    expect(page).to have_closed_claims_count 0
  end

  private

  def page
    @page ||= Pages::Base.new
  end
end
