'use strict';

angular.module('Dashboard').service('GlobalDataService', [
  'ClaimService',
  'ClaimsService',
  'ErrorHandlerService',
  'HiddenColumnsFactory',
  function(ClaimService, ClaimsService, ErrorHandlerService, HiddenColumnsFactory) {
    var hiddenColumns = {},
        self = this;

    self.activeClaim = '';
    self.activeFilter = '';
    self.columns = [
      { name: 'claim_id', display: 'Claim ID', hideable: false },
      { name: 'due_date', display: 'Due Date', hideable: true },
      { name: 'flags', display: 'Flags', hideable: true },
      { name: 'age', display: 'Note Age', hideable: true },
      { name: 'adjuster', display: 'Adjuster', hideable: true },
      { name: 'state', display: 'State', hideable: true },
      { name: 'claimant', display: 'Claimant', hideable: true },
      { name: 'insured', display: 'Insured', hideable: true },
      { name: 'total_reserve', display: 'Total Res', hideable: true },
      { name: 'total_paid', display: 'Total Paid', hideable: true },
      { name: 'indem', display: 'Indem Res', hideable: true },
      { name: 'med', display: 'Med Res', hideable: true },
      { name: 'legal', display: 'Legal Res', hideable: true },
      { name: 'entry', display: 'Last Entry', hideable: true },
    ];
    self.dailyEventCounts = {};
    self.daysSinceLastNoteBucketCounts = {};
    self.detailVisible = false;
    self.dueTodayCount = 0;
    self.filterCounts = {};
    self.flagsEnabled = true;
    self.hiddenColumns = {};
    self.loadingClaims = false;
    self.loadingApp = true;
    self.maxDaysSinceLastNoteBucketCount;
    self.searchString = '';
    self.sidebarVisible = true;
    self.sortAscending = true;
    self.sortColumn = 'claim_id';
    self.user;
    self.view = 'dashboard';

    function filterClaims() {
      self.filteredClaims = ClaimsService.filterClaims(self.claims, self.activeFilter,
        self.calendarDay, self.searchString);
    }

    function processColumns (columns) {
      _.each(columns, function (column) {
       hiddenColumns[column.column_name] = ! column.display;
      });
      return hiddenColumns;
    }

    self.buildCalendar = function (claims, updateClaims) {
      self.claims = claims;

      if (updateClaims) {
        ClaimsService.updateClaims(claims, self.user);
        ClaimsService.setDaysSinceLastNote(self.claims);
        ClaimsService.setLastNoteFlags(self.claims);
      }

      self.claims = ClaimsService.sortClaims(self.claims, self.sortColumn, self.sortAscending);
      filterClaims();
      self.dailyEventCounts = ClaimsService.claimEventCounts(self.claims);
      self.dueTodayCount = ClaimsService.dueTodayCount(self.claims);
      self.filterCounts = ClaimsService.claimFilterCounts(self.claims);
      self.daysSinceLastNoteBucketCounts = ClaimsService.daysSinceLastNoteBucketCounts(self.claims);
      self.maxDaysSinceLastNoteBucketCount =
        ClaimsService.maxDaysSinceLastNoteBucketCount(self.daysSinceLastNoteBucketCounts);
      if (! self.claims || ! self.claims.length) {
        self.view = 'inbox';
      }
    };

    self.closeClaimDetail = function () {
      self.detailVisible = false;
      self.loadingClaims = false;
      if (self.activeClaim && self.activeClaim.details && self.activeClaim.details[0] &&
        ! self.activeClaim.details[0].id) {
        self.activeClaim.details.splice(0, 1);
      }
    };

    self.columnVisible = function (columnName) {
      var column = _.find(self.columns, function (col) {
        return col.name === columnName;
      });
      if (! column) {
        return false;
      }
      if (column.hideable && self.hiddenColumns[column.name]) {
        return false;
      }
      if (column.name === 'flags' && ! self.flagsVisible) {
        return false;
      }
      return true;
    };

    self.filterCount = function (filter) {
      return self.filterCounts[filter] || 0;
    };

    self.fixDate = function (date) {
      return moment(date).startOf('day').toDate();
    };

    self.openClaimDetail = function (claim) {
      self.detailVisible = true;
      self.activeClaim = claim;
    };

    self.rebuildCalendar = function (updateClaims) {
      self.buildCalendar(self.claims, updateClaims);
    };

    self.search = function () {
      if (self.searchString && self.searchString.length) {
        self.setFilter('search');
      }
      else {
        self.setFilter('');
      }
    };

    self.setClaimColumns = function () {
      HiddenColumnsFactory.query().$promise.then(function (response) {
        self.hiddenColumns = processColumns(response);
      }, ErrorHandlerService.general);
    };

    self.setFilter = function (filter) {
      self.closeClaimDetail();
      self.activeFilter = filter;
      if (filter !== 'search') {
        self.searchString = '';
      }
      self.view = 'inbox';
      filterClaims();
    };

    self.setSelectedDay = function (date) {
      if (date) {
        self.calendarDay = new Date(date);
      }
      else {
        self.calendarDay = new Date();
      }
      self.setFilter('day');
    };

    self.setSort = function (columnName, ascending) {
      var column = _.find(self.columns, function (column) {
        return column.name === columnName;
      });
      if (column) {
        self.sortColumn = columnName;
        self.sortAscending = ascending;
        self.rebuildCalendar();
      }
    };

    self.showDashboard = function () {
      self.view = 'dashboard';
      self.detailVisible = false;
    };

    self.showInbox = function () {
      self.setFilter('');
      self.view = 'inbox';
    };

    self.statDurationPct = function () {
      if (self.filterCounts.open > 0) {
        return self.filterCounts.duration / self.filterCounts.open * 100;
      }
      return 0;
    };

    self.statTouchPct = function () {
      if (self.filterCounts.open > 0) {
        return self.filterCounts.touch / self.filterCounts.open * 100;
      }
      return 0;
    };

    self.calendarDay = self.fixDate();
  }
]);
