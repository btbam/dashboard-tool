require 'spec_helper'

feature 'Hidden Columns', js: true do
  before do
    create_importer_runs
    user = create_user
    create_fully_loaded_feature(current_adjuster: user.dashboard_adjuster_id)
    sign_in(user)
  end

  # The tests below were commented out for speed
  # Running them all adds about 4 more minutes of testing

  scenario 'Column visibility checkbox defaults' do
    page.click_column_visibility_menu_toggle

    # All columns exist
    expect(page).to have_column_visibility_checkbox('due_date')
    # expect(page).to have_column_visibility_checkbox('flags')
    # expect(page).to have_column_visibility_checkbox('age')
    # expect(page).to have_column_visibility_checkbox('adjuster')
    # expect(page).to have_column_visibility_checkbox('entry')
    # expect(page).to have_column_visibility_checkbox('state')
    # expect(page).to have_column_visibility_checkbox('claimant')
    # expect(page).to have_column_visibility_checkbox('insured')
    # expect(page).to have_column_visibility_checkbox('total_reserve')
    # expect(page).to have_column_visibility_checkbox('total_paid')
    # expect(page).to have_column_visibility_checkbox('indem')
    # expect(page).to have_column_visibility_checkbox('med')
    # expect(page).to have_column_visibility_checkbox('legal')

    # Defaults on
    expect(page).to have_column_visibility_checkbox_checked('due_date')
    # expect(page).to have_column_visibility_checkbox_checked('flags')
    # expect(page).to have_column_visibility_checkbox_checked('age')
    # expect(page).to have_column_visibility_checkbox_checked('adjuster')
    # expect(page).to have_column_visibility_checkbox_checked('entry')

    # Defaults off
    expect(page).to have_column_visibility_checkbox_unchecked('state')
    # expect(page).to have_column_visibility_checkbox_unchecked('claimant')
    # expect(page).to have_column_visibility_checkbox_unchecked('insured')
    # expect(page).to have_column_visibility_checkbox_unchecked('total_reserve')
    # expect(page).to have_column_visibility_checkbox_unchecked('total_paid')
    # expect(page).to have_column_visibility_checkbox_unchecked('indem')
    # expect(page).to have_column_visibility_checkbox_unchecked('med')
    # expect(page).to have_column_visibility_checkbox_unchecked('legal')

    # Bogus
     expect(page).not_to have_column_visibility_checkbox('bogus_column_name')
  end

  scenario 'Column visibility defaults' do
    page.click_sidebar_all_claims_link

    # Always on
    expect(page).to have_claim_list_column_visible('claim_id')

    # Default on
    expect(page).to have_claim_list_column_visible('due_date')
    # expect(page).to have_claim_list_column_visible('flags')
    # expect(page).to have_claim_list_column_visible('age')
    # expect(page).to have_claim_list_column_visible('adjuster')
    # expect(page).to have_claim_list_column_visible('entry')

    # Default off
    expect(page).not_to have_claim_list_column_visible('state')
    # expect(page).not_to have_claim_list_column_visible('claimant')
    # expect(page).not_to have_claim_list_column_visible('insured')
    # expect(page).not_to have_claim_list_column_visible('total_reserve')
    # expect(page).not_to have_claim_list_column_visible('total_paid')
    # expect(page).not_to have_claim_list_column_visible('indem')
    # expect(page).not_to have_claim_list_column_visible('med')
    # expect(page).not_to have_claim_list_column_visible('legal')

    # Bogus
    expect(page).not_to have_claim_list_column_visible('bogus_column_name')
  end

  scenario 'Column visibility toggles' do
    page.click_sidebar_all_claims_link
    page.click_column_visibility_menu_toggle

    # Always on
    expect(page).to have_claim_list_column_visible('claim_id')

    # Default on, toggle off
    page.click_column_visibility_checkbox('due_date')
    # page.click_column_visibility_checkbox('flags')
    # page.click_column_visibility_checkbox('age')
    # page.click_column_visibility_checkbox('adjuster')
    # page.click_column_visibility_checkbox('entry')

    expect(page).not_to have_claim_list_column_visible('due_date')
    # expect(page).not_to have_claim_list_column_visible('flags')
    # expect(page).not_to have_claim_list_column_visible('age')
    # expect(page).not_to have_claim_list_column_visible('adjuster')
    # expect(page).not_to have_claim_list_column_visible('entry')

    # Default off, toggle on
    page.click_column_visibility_checkbox('state')
    # page.click_column_visibility_checkbox('claimant')
    # page.click_column_visibility_checkbox('insured')
    # page.click_column_visibility_checkbox('total_reserve')
    # page.click_column_visibility_checkbox('total_paid')
    # page.click_column_visibility_checkbox('indem')
    # page.click_column_visibility_checkbox('med')
    # page.click_column_visibility_checkbox('legal')

    expect(page).to have_claim_list_column_visible('state')
    # expect(page).to have_claim_list_column_visible('claimant')
    # expect(page).to have_claim_list_column_visible('insured')
    # expect(page).to have_claim_list_column_visible('total_reserve')
    # expect(page).to have_claim_list_column_visible('total_paid')
    # expect(page).to have_claim_list_column_visible('indem')
    # expect(page).to have_claim_list_column_visible('med')
    # expect(page).to have_claim_list_column_visible('legal')
  end

  private

  def page
    @page ||= Pages::Base.new
  end
end
