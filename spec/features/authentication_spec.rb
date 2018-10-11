require 'spec_helper'

feature 'Authentication', js: true do
  before do
    create_importer_runs
    @user = create_user
    visit '/'
  end

  scenario 'A user logs in with token' do
    page.visit_auth_token_url(@user)
    page.click_dashboard_link
    expect(page).to have_dashboard_visible
  end

  scenario 'A user logs out' do
    page.visit_auth_token_url(@user)
    page.click_dashboard_link
    expect(page).to have_dashboard_visible

    page.click_user_menu_toggle
    page.click_logout_link
    expect(page).to have_location('/users/sign_in')
  end

  private

  def page
    @page ||= Pages::Base.new
  end
end
