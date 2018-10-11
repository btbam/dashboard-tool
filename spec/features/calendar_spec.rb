require 'spec_helper'
require 'date'

feature 'Calendar', js: true do
  before do
    create_importer_runs
    user = create_user
    sign_in(user)
  end

  scenario 'current day' do
    page.click_calendar_month_increment_link
    expect(page).not_to have_current_calendar_day
    page.click_calendar_month_decrement_link

    expect(page).to have_current_calendar_day Date.today.strftime('%e').to_i
    expect(page).to have_calendar_month Date.today.strftime('%b %Y')    
  end

  scenario 'current month' do
    expect(page).to have_calendar_month Date.today.strftime('%b %Y')
  end
 
  scenario 'increment month' do
    next_month = Date.today >> 1
    page.click_calendar_month_increment_link
    expect(page).to have_calendar_month next_month.strftime('%b %Y')
    page.click_calendar_month_decrement_link
  end

  scenario 'decrement month' do
    previous_month = Date.today << 1
    page.click_calendar_month_decrement_link
    expect(page).to have_calendar_month previous_month.strftime('%b %Y')
  end

  private

  def page
    @page ||= Pages::Base.new
  end
end
