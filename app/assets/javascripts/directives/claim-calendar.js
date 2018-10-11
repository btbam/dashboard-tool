'use strict';

angular.module('Dashboard').directive('claimCalendar', [
  'GlobalDataService',
  function (GlobalDataService) {
    return {
      restrict: 'E',
      scope: {
      },
      templateUrl: '/assets/templates/claim-calendar.html',
      link: function (scope) {
        scope.currentMonth = moment(new Date());
        scope.globalDataService = GlobalDataService;
        scope.selectedDay = moment(new Date());
        scope.today = moment(new Date()).startOf('day');
        scope.weekdays = [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ];
        scope.weekRows = [];

        function firstOfCurrentMonth () {
          return scope.currentMonth.clone().startOf('month');
        }

        scope.decrementCurrentMonth = function () {
          var newMonth = scope.currentMonth.clone().subtract(1, 'month');
          scope.setCurrentMonth(newMonth);
        };

        scope.getClaimCount = function (date) {
          var key = date.format('YYYYMMDD');
          return GlobalDataService.dailyEventCounts[key] || 0;
        };

        scope.incrementCurrentMonth = function () {
          var newMonth = scope.currentMonth.clone().add(1, 'month');
          scope.setCurrentMonth(newMonth);
        };

        scope.inMonth = function (date) {
          return scope.currentMonth.isSame(date, 'month');
        };

        scope.isSelectedDay = function (date) {
          return scope.selectedDay.isSame(date, 'day');   
        };

        scope.isToday = function (date) {
          return scope.today.isSame(date, 'day');
        };

        scope.setCurrentMonth = function (date) {          
          var currentMoment,
            dayIndex,
            firstOfMonthWeekday,
            rowDates = [],
            rowIndex;

          scope.currentMonth = moment(date).startOf('month');
          scope.weekRows = [];
          firstOfMonthWeekday = firstOfCurrentMonth().day();
          currentMoment = firstOfCurrentMonth().subtract(firstOfMonthWeekday + 1, 'days');

          for (rowIndex = 0; rowIndex < 6; rowIndex++) {
            rowDates = [];
            for (dayIndex = 0; dayIndex < 7; dayIndex++) {
              rowDates.push(currentMoment.add(1, 'days').clone());
            }
            scope.weekRows.push(rowDates);
          }
        };

        scope.setSelectedDay = function (date) {
          if (scope.isToday(date) || scope.getClaimCount(date)) {
            scope.selectedDay = date;
            GlobalDataService.view = 'inbox';
            GlobalDataService.setSelectedDay(date);
          }
        };

        scope.setToday = function () {
          scope.setCurrentMonth(scope.today);
          scope.setSelectedDay(scope.today);
        };

        scope.setCurrentMonth(scope.currentMonth);
      }
    };
  }
]);
