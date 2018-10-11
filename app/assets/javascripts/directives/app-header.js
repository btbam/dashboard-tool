'use strict';

angular.module('Dashboard').directive('appHeader', [
  '$timeout',
  'AppHeaderService',
  'GlobalDataService',
  'HiddenColumnsFactory',
  function ($timeout, AppHeaderService, GlobalDataService, HiddenColumnsFactory) {
    return {
      restrict: 'E',
      scope: {},
      templateUrl: '/assets/templates/app-header.html',
      link: function (scope) {
        var resource = '', timeoutHiddenColumns, timeoutSearch;
        scope.columnVisibilityMenuVisible = false;
        scope.globalDataService = GlobalDataService;
        scope.header = AppHeaderService;
        scope.searchString = '';
        scope.userMenuVisible = false;

        scope.clearSearchString = function () {
          scope.searchString = '';
          GlobalDataService.searchString = '';
          GlobalDataService.search();
        };

        scope.searchChange = function () {
          if (timeoutSearch) {
            $timeout.cancel(timeoutSearch);
          }

          timeoutSearch = $timeout(function () {
            GlobalDataService.searchString = scope.searchString.length >= 3 ? scope.searchString : '';
            GlobalDataService.search();
          }, 1000);
        };

        scope.toggleColumnVisibility = function (column) {
          if (timeoutHiddenColumns) {
            $timeout.cancel(timeoutHiddenColumns);
          }

          GlobalDataService.hiddenColumns[column] = ! GlobalDataService.hiddenColumns[column];

          timeoutHiddenColumns = $timeout(function () {
            resource = new HiddenColumnsFactory(GlobalDataService.hiddenColumns);
            resource.$update();
          }, 3000);
        };
      }
    };
}]);
