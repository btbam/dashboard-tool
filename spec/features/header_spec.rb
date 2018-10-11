require 'spec_helper'

feature 'Header', js: true do
  before do
    create_importer_runs
    user = create_user
    sign_in(user)
  end

  scenario 'Last updated date shows in header' do
    expect(page).to have_updated_timestamp
  end

  scenario 'Can open and close sidebar' do
    expect(page).to have_sidebar_open
    page.click_sidebar_toggle
    expect(page).to have_sidebar_closed
    page.click_sidebar_toggle
    expect(page).to have_sidebar_open
  end

  scenario 'Has feedback link' do
    expect(page).to have_feedback_link
  end

  scenario 'Can open and close column visibility menu' do
    expect(page).to have_column_visibility_menu_closed
    page.click_column_visibility_menu_toggle
    expect(page).to have_column_visibility_menu_open
    page.click_column_visibility_menu_toggle
    expect(page).to have_column_visibility_menu_closed
  end

  scenario 'Can open and close user menu' do
    expect(page).to have_user_menu_closed
    page.click_user_menu_toggle
    expect(page).to have_user_menu_open
    page.click_user_menu_toggle
    expect(page).to have_user_menu_closed
  end

  private

  def page
    @page ||= Pages::Base.new
  end
end
