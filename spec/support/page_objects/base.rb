module Pages
  class Base
    include Capybara::Angular::DSL

    def has_adjuster_filter_value?(adjuster_name)
      find('#context-switcher input.search').value == adjuster_name
    end

    def click_add_reminder_link
      find('#add-reminder-button').click
    end

    def click_adjuster_result(adjuster_name)
      find('#context-switcher ul.dropdown-menu li a', text: adjuster_name).click
    end

    def click_calendar_month_decrement_link
      find('div.calendar a.decrement-month').click
    end

    def click_calendar_month_increment_link
      find('div.calendar a.increment-month').click
    end

    def click_calendar_today_link
      find('div.calendar a.today').click
    end

    def click_cancel_reminder_link
      find('a#cancel-note').click
    end

    def click_claim_list_row(row)
      find('table.claim-list tbody tr:nth-child(' + row.to_s + ')').click
    end

    def click_clear_context_switcher
      find('#context-switcher a.clear-context-switcher').click
    end

    def click_close_claim_link
      find('div.claim-detail-footer a', :text => 'Mark as Closed').click
    end

    def click_column_visibility_checkbox(column = '')
      find('#column-visibility-menu input[name=column_' + column + ']').click
    end

    def click_column_visibility_menu_toggle
      find('header .column-visibility-menu-toggle').click
    end

    def click_dashboard_link
      find('#sidebar li.dashboard').click
    end

    def click_logout_link
      visit find('#user-menu a.logout')[:href]
    end

    def click_reminder_type(reminder_type)
      find('div.select-label li.' + reminder_type).click
    end

    def click_reopen_claim_link
      find('div.claim-detail-footer a', :text => 'Reopen').click
    end

    def click_save_reminder_link
      find('a#save-note').click
    end

    def click_sidebar_all_claims_link
        find('#sidebar li.all-claims').click
    end

    def click_sidebar_toggle
      find('header img.hamburger').click
    end

    def click_user_menu_toggle
      find('#user-menu-toggle').click
    end

    def delete_note(row = 0)
      find('table.notes tr:nth-child(' + row.to_s + ')').hover
      find('div.author-actions ul.active li.delete-note').click
    end

    def edit_note(row = 0)
      find('table.notes tr:nth-child(' + row.to_s + ')').hover
      find('div.author-actions ul.active li.edit-note').click
    end

    def find_number_in_parentheses(str)
      str.scan(/\((\d+)\)/).join.to_i
    end

    def has_adjuster_result_count?(count)
      find('#context-switcher ul.dropdown-menu').all('li').size == count
    end

    def has_all_claims_count?(count)
      find_number_in_parentheses(find('#sidebar li.all-claims').text) == count
    end

    def has_calendar_month?(month)
      find('div.calendar .month').text == month
    end

    def has_claim_list_column_visible?(column)
      has_css?('table.claim-list th.' + column)
    end

    def has_claim_list_count?(count)
      find('table.claim-list tbody').all('tr').size == count
    end

    def has_closed_claims_count?(count)
      find_number_in_parentheses(find('#sidebar li.closed').text) == count
    end

    def has_column_visibility_checkbox?(column = '')
      has_checked_field?('column_' + column) || has_unchecked_field?('column_' + column)
    end

    def has_column_visibility_checkbox_checked?(column = '')
      has_checked_field?('column_' + column)
    end

    def has_column_visibility_checkbox_unchecked?(column = '')
      has_unchecked_field?('column_' + column)
    end

    def has_column_visibility_menu_closed?
      has_css?('#column-visibility-menu.off')
    end

    def has_column_visibility_menu_open?
      has_css?('#column-visibility-menu') && has_no_css?('#column-visibility-menu.off')
    end       

    def has_current_calendar_day?(day = '')
      if (has_css?('table.calendar td.today div'))
        return find('table.calendar td.today div').text.to_i == day
      end
    end

    def has_dashboard_visible?
      has_css?('#dashboard') && has_no_css?('#dashboard.off')
    end

    def has_dashboard_last_note_count?(severity = '', count = '')
      find('#dashboard tr.lastnote-' + severity + ' td.count').text.to_i == count
    end

    def has_feedback_link?
      href = 'mailto:dashboard@dashboard.com?Subject=Dashboard Feedback'
      has_css?('header a.send-feedback[href="' + href + '"]')
    end

    def has_last_note_graph_bar_count?(severity = '', count = '')
      total_bars = find('histogram#lastnote-' + severity).all('rect.bar').size
      zero_height_bars = find('histogram#lastnote-' + severity).all('rect.bar[height="0"]').size
      total_bars - zero_height_bars == count
    end

    def has_location?(page = '')
      current_path == page
    end

    def has_no_context_switcher_results?
      has_css?('#context-switcher div.no-results')
    end

    def has_note_count?(count = 0)
      find('table.notes').all('tr').size == count
    end

    def has_note_text?(row = 0, text = '')
      find('table.notes tr:nth-child(' + row.to_s + ') div.text').text == text
    end

    def has_sidebar_closed?
      has_css?('#sidebar.closed')
    end

    def has_sidebar_open?
      has_css?('#sidebar') && has_no_css?('#sidebar.closed')
    end

    def has_updated_timestamp?
      last_updated = find('header .last-updated').text
      last_updated =~ /^Updated: \d{2}\/\d{2}\/\d{2}/
    end

    def has_user_menu_closed?
      has_css?('#user-menu.off')
    end

    def has_user_menu_open?
      has_css?('#user-menu') && has_no_css?('#user-menu.off')
    end

    def set_adjuster_filter_text(text)
      set_typeahead_value('#context-switcher input.search', text)
    end

    # This is a workaround for the angular ui typeahead/poltergeist bug
    def set_typeahead_value(selector, query)
      find(selector).native.send_keys(*query.chars)
    end

    def set_dashboard_last_note_timeframe(timeframe)
      find('#dashboard table.lastnote select').select(timeframe)
    end

    def set_reminder_text(text)
      find('textarea#note-text').set(text)
    end

    def set_search_text(search_text)
      find('header input.search-all').set(search_text)
    end

    # Unlike the session helper's sign_in method, this explicitly uses the auth token URL
    def visit_auth_token_url(user)
      visit '/?authentication_token=' + user.authentication_token
    end
  end
end
