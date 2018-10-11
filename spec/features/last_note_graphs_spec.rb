require 'spec_helper'

feature 'Last Note Graphs', js: true do
  before do
    create_last_note_graph_data
  end

  after do
    cleanup_data
  end

  scenario 'table counts monthly' do
    expect(page).to have_dashboard_last_note_count('low', 1)
    expect(page).to have_dashboard_last_note_count('med-low', 2)
    expect(page).to have_dashboard_last_note_count('med', 1)
    expect(page).to have_dashboard_last_note_count('high', 1)
  end

  scenario 'graphs monthly' do
    expect(page).to have_last_note_graph_bar_count('low', 1)
    expect(page).to have_last_note_graph_bar_count('med-low', 2)
    expect(page).to have_last_note_graph_bar_count('med', 1)
    expect(page).to have_last_note_graph_bar_count('high', 1)
  end

  scenario 'table counts weekly' do
    page.set_dashboard_last_note_timeframe('Weekly')
    expect(page).to have_dashboard_last_note_count('low', 1)
    expect(page).to have_dashboard_last_note_count('med-low', 0)
    expect(page).to have_dashboard_last_note_count('med', 0)
    expect(page).to have_dashboard_last_note_count('high', 4)
  end

  scenario 'graphs weekly' do
    page.set_dashboard_last_note_timeframe('Weekly')
    expect(page).to have_last_note_graph_bar_count('low', 1)
    expect(page).to have_last_note_graph_bar_count('med-low', 0)
    expect(page).to have_last_note_graph_bar_count('med', 0)
    expect(page).to have_last_note_graph_bar_count('high', 2)
  end

  private

  def page
    @page ||= Pages::Base.new
  end
end
