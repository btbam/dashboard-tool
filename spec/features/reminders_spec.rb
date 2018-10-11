require 'spec_helper'
require 'date'

feature 'Reminders', js: true do
  before do
    create_importer_runs
    user = create_user
    create_fully_loaded_feature(current_adjuster: user.dashboard_adjuster_id)
    sign_in(user)
  end

  scenario 'edit reminder' do
    page.click_sidebar_all_claims_link
    page.click_claim_list_row(1)

    # Create reminder and confirm text
    page.click_add_reminder_link
    page.click_reminder_type('follow-up')
    page.set_reminder_text('bogus follow-up message')
    page.click_save_reminder_link
    expect(page).to have_note_text(1, 'bogus follow-up message')

    # Edit reminder and confirm text
    page.edit_note(1)
    page.set_reminder_text('business interruptus')
    page.click_save_reminder_link
    expect(page).to have_note_text(1, 'business interruptus')
  end

  scenario 'add reminder' do
    expect(page).to have_all_claims_count 1
    page.click_sidebar_all_claims_link
    page.click_claim_list_row(1)

    # Created a single claim with 5 external notes
    expect(page).to have_note_count(5)

    # Cancel
    page.click_add_reminder_link
    page.click_cancel_reminder_link

    # Add Follow-up Reminder
    page.click_add_reminder_link
    page.click_reminder_type('follow-up')
    page.set_reminder_text('bogus follow-up message')
    page.click_save_reminder_link
    expect(page).to have_note_count(6)

    # Add Email Reminder
    page.click_add_reminder_link
    page.click_reminder_type('email')
    page.set_reminder_text('bogus email message')
    page.click_save_reminder_link
    expect(page).to have_note_count(7)

    # Add Call Reminder
    page.click_add_reminder_link
    page.click_reminder_type('call')
    page.set_reminder_text('bogus call message')
    page.click_save_reminder_link
    expect(page).to have_note_count(8)


    # Delete reminders
    page.delete_note(3)
    expect(page).to have_note_count(7)

    page.delete_note(2)
    expect(page).to have_note_count(6)

    page.delete_note(1)
    expect(page).to have_note_count(5)
  end

  private

  def page
    @page ||= Pages::Base.new
  end
end
