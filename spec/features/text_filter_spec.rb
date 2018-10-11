require 'spec_helper'

feature 'Text Filter', js: true do
  before do
    @user = create_text_filter_data
  end

  after do
    cleanup_data
  end

  scenario 'claim_id' do
    page.set_search_text('111-222222')
    expect(page).to have_claim_list_count 1

    page.set_search_text('333-444444')
    expect(page).to have_claim_list_count 1

    page.set_search_text('555-666666')
    expect(page).to have_claim_list_count 1
  end

  scenario 'claimant name' do
    page.set_search_text('emilia clarke')
    expect(page).to have_claim_list_count 1

    page.set_search_text('scarlett johannson')
    expect(page).to have_claim_list_count 1

    page.set_search_text('morena baccarin')
    expect(page).to have_claim_list_count 1
  end

  scenario 'state' do
    page.set_search_text('state_or')
    expect(page).to have_claim_list_count 1

    page.set_search_text('state_ca')
    expect(page).to have_claim_list_count 1

    page.set_search_text('state_wa')
    expect(page).to have_claim_list_count 1
  end

  scenario 'note text' do
    page.set_search_text('NOTE TEXT 111-222222')
    expect(page).to have_claim_list_count 1

    page.set_search_text('NOTE TEXT 333-444444')
    expect(page).to have_claim_list_count 1

    page.set_search_text('NOTE TEXT 555-666666')
    expect(page).to have_claim_list_count 1
  end

  scenario 'Text search adjuster name' do
    page.set_search_text('jessica alba')
    expect(page).to have_claim_list_count 3
  end

  scenario 'insured' do
    page.set_search_text('Natalie Portman')
    expect(page).to have_claim_list_count 1

    page.set_search_text('January Jones')
    expect(page).to have_claim_list_count 1

    page.set_search_text('Eliza Dushku')
    expect(page).to have_claim_list_count 1
  end

  private

  def page
    @page ||= Pages::Base.new
  end
end
