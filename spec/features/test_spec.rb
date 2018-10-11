require 'spec_helper'

feature 'Testing the tests', js: true do
  scenario 'A user attempts to view main page' do
    create_importer_runs
    user = create_user
    sign_in(user)
    expect(page).to have_content "No results match current criteria"
  end
end
