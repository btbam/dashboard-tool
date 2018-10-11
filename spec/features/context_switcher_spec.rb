require 'spec_helper'

feature 'Context Switcher', js: true do
  before do
    create_context_switcher_data
  end

  after do
    cleanup_data
  end

  scenario 'change adjuster no results' do
    page.set_adjuster_filter_text('NO RESULTS EXIST MOFOS')
    expect(page).to have_no_context_switcher_results
  end

  scenario 'clear context switcher' do
    page.set_adjuster_filter_text('natalie')
    expect(page).to have_adjuster_filter_value('natalie')

    page.click_clear_context_switcher
    expect(page).to have_adjuster_filter_value('')
  end

  scenario 'change adjuster' do
    page.click_sidebar_all_claims_link
    expect(page).to have_all_claims_count(6)

    page.set_adjuster_filter_text('natalie')
    expect(page).to have_adjuster_result_count(2)
    page.click_adjuster_result('Natalie Imbruglia')
    expect(page).to have_all_claims_count(2)

    page.click_clear_context_switcher

    page.set_adjuster_filter_text('natalie')
    page.click_adjuster_result('Natalie Injustice')
    expect(page).to have_all_claims_count(3)
  end

  private

  def page
    @page ||= Pages::Base.new
  end
end
