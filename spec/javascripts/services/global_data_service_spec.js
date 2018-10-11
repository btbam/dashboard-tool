'use strict';

describe('Global Data Service', function () {
  var ClaimsService, GlobalDataService;

  beforeEach(module('Dashboard'));
  beforeEach(inject(function (_ClaimsService_, _GlobalDataService_) {
    ClaimsService = _ClaimsService_;
    GlobalDataService = _GlobalDataService_;
  }));

  it('should build calendar', function () {
    spyOn(ClaimsService, 'updateClaims');
    spyOn(ClaimsService, 'setDaysSinceLastNote');
    spyOn(ClaimsService, 'setLastNoteFlags');
    spyOn(ClaimsService, 'sortClaims');
    spyOn(ClaimsService, 'claimEventCounts');
    spyOn(ClaimsService, 'dueTodayCount');
    spyOn(ClaimsService, 'claimFilterCounts');
    spyOn(ClaimsService, 'daysSinceLastNoteBucketCounts');
    spyOn(ClaimsService, 'maxDaysSinceLastNoteBucketCount');

    GlobalDataService.buildCalendar([], true);

    expect(ClaimsService.updateClaims).toHaveBeenCalled();
    expect(ClaimsService.setDaysSinceLastNote).toHaveBeenCalled();
    expect(ClaimsService.setLastNoteFlags).toHaveBeenCalled();
    expect(ClaimsService.sortClaims).toHaveBeenCalled();
    expect(ClaimsService.claimEventCounts).toHaveBeenCalled();
    expect(ClaimsService.dueTodayCount).toHaveBeenCalled();
    expect(ClaimsService.claimFilterCounts).toHaveBeenCalled();
    expect(ClaimsService.daysSinceLastNoteBucketCounts);
    expect(ClaimsService.maxDaysSinceLastNoteBucketCount);
  });

  it('should close claim detail', function () {
    GlobalDataService.detailVisible = true;
    GlobalDataService.loadingClaims = true;
    GlobalDataService.activeClaim = { id: 123, details: [ { bogus: 'value' }, { id: 45 } ] };
    GlobalDataService.closeClaimDetail();
    expect(GlobalDataService.detailVisible).toBe(false);
    expect(GlobalDataService.loadingClaims).toBe(false);
    expect(GlobalDataService.activeClaim.details.length).toBe(1);
  });

  it('should return column visible', function () {
    expect(GlobalDataService.columnVisible('bogus_column_name')).toBeFalsy();

    GlobalDataService.flagsVisible = false;
    expect(GlobalDataService.columnVisible('flags')).toBeFalsy();

    GlobalDataService.flagsVisible = true;
    expect(GlobalDataService.columnVisible('flags')).toBeTruthy();

    _.each(GlobalDataService.columns, function (column) {
      if (column.hideable) {
        GlobalDataService.hiddenColumns[column.name] = true;
        expect(GlobalDataService.columnVisible(column.name)).toBeFalsy();
      }

      GlobalDataService.hiddenColumns[column.name] = false;
      expect(GlobalDataService.columnVisible(column.name)).toBeTruthy();
    });
  });

  it('should return filter counts', function () {
    var filter, filterCounts = { new: 100, closed: 500, open: 400 };
    GlobalDataService.filterCounts = filterCounts;
    for (filter in filterCounts) {
      expect(GlobalDataService.filterCount(filter)).toBe(filterCounts[filter]);
    }
    expect(GlobalDataService.filterCount('imaginary')).toBe(0);
  });

  it('should fix dates', function () {
    var date, dates, momentDate;

    dates = {
      'Thu, 21 Jan 2016 23:42:46 UTC': '20160121',
      '2016-12-01': '20161201',
      'January 19, 2012': '20120119',
      'Tue, 10 Aug 2010 23:20:19 -0400 (EDT)': '20100811'
    };

    for (date in dates) {
      momentDate = new moment(GlobalDataService.fixDate(new Date(date)));
      expect(momentDate.format('YYYYMMDD')).toBe(dates[date]);
    }
  });

  it('should open claim detail', function () {
    var claim = { id: 123 };
    GlobalDataService.detailVisible = false;
    GlobalDataService.activeClaim = {};
    GlobalDataService.openClaimDetail(claim);
    expect(GlobalDataService.detailVisible).toBe(true);
    expect(GlobalDataService.activeClaim).toBe(claim);
  });

  it('should rebuild calendar', function () {
    spyOn(GlobalDataService, 'buildCalendar');
    GlobalDataService.rebuildCalendar();
    expect(GlobalDataService.buildCalendar).toHaveBeenCalled();
  });

  it('should search', function () {
    GlobalDataService.activeFilter = 'new';
    GlobalDataService.searchString = 'batman';
    GlobalDataService.search();
    expect(GlobalDataService.activeFilter).toBe('search');

    GlobalDataService.searchString = '';
    GlobalDataService.search();
    expect(GlobalDataService.activeFilter).toBe('');
  });

  it('should set filter', function () {
    var filters = [ 'new', 'diary', 'call', 'email', 'follow-up', 'reminder', 'notification', 'touch', 'duration',
      'lastnote', 'lastnote-low', 'lastnote-med-low', 'lastnote-med', 'lastnote-high', 'day', 'search', 'closed',
      '', 'open', 'future-filter' ];

    _.each(filters, function (filter) {
      GlobalDataService.searchString = 'beavis';
      GlobalDataService.setFilter(filter);
      expect(GlobalDataService.detailVisible).toBe(false);
      expect(GlobalDataService.activeFilter).toBe(filter);
      expect(GlobalDataService.searchString).toBe(filter === 'search' ? 'beavis' : '');
      expect(GlobalDataService.view).toBe('inbox');
    });
 });

  it('should set selected day', function () {
    var today = new Date();
    GlobalDataService.setSelectedDay();
    expect(GlobalDataService.activeFilter).toBe('day');
    expect(GlobalDataService.calendarDay).toEqual(today);

    GlobalDataService.setSelectedDay('2016-11-06');
    expect(GlobalDataService.activeFilter).toBe('day');
    expect(GlobalDataService.calendarDay).toEqual(new Date('2016-11-06'));
  });

  it('should set sort', function () {
    spyOn(GlobalDataService, 'rebuildCalendar');

    // Ascending
    _.each(GlobalDataService.columns, function (column) {
      GlobalDataService.setSort(column.name, true);
      expect(GlobalDataService.sortColumn).toEqual(column.name);
      expect(GlobalDataService.sortAscending).toBe(true);
      expect(GlobalDataService.rebuildCalendar).toHaveBeenCalled();
    });

    // Descending
    _.each(GlobalDataService.columns, function (column) {
      GlobalDataService.setSort(column.name, false);
      expect(GlobalDataService.sortColumn).toEqual(column.name);
      expect(GlobalDataService.sortAscending).toBe(false);
      expect(GlobalDataService.rebuildCalendar).toHaveBeenCalled();
    });
  });

  it('should show dashboard', function () {
    GlobalDataService.showDashboard();
    expect(GlobalDataService.view).toEqual('dashboard');
    expect(GlobalDataService.detailVisible).toBe(false);
  });

  it('should show inbox', function () {
    spyOn(GlobalDataService, 'setFilter');
    GlobalDataService.showInbox();
    expect(GlobalDataService.view).toEqual('inbox');
    expect(GlobalDataService.setFilter).toHaveBeenCalled();
  });

  it('should calculate duration pct', function () {
    GlobalDataService.filterCounts.open = 500;
    GlobalDataService.filterCounts.duration = 100;
    expect(GlobalDataService.statDurationPct()).toEqual(20);

    GlobalDataService.filterCounts.open = 0;
    GlobalDataService.filterCounts.duration = 100;
    expect(GlobalDataService.statDurationPct()).toEqual(0);

    GlobalDataService.filterCounts.open = 500;
    GlobalDataService.filterCounts.duration = 0;
    expect(GlobalDataService.statDurationPct()).toEqual(0);
  });

  it('should calculate touch pct', function () {
    GlobalDataService.filterCounts.open = 1000;
    GlobalDataService.filterCounts.touch = 100;
    expect(GlobalDataService.statTouchPct()).toEqual(10);

    GlobalDataService.filterCounts.open = 0;
    GlobalDataService.filterCounts.touch = 500;
    expect(GlobalDataService.statTouchPct()).toEqual(0);

    GlobalDataService.filterCounts.open = 1500;
    GlobalDataService.filterCounts.touch = 0;
    expect(GlobalDataService.statTouchPct()).toEqual(0);
  });
});
