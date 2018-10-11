'use strict';

angular.module('Dashboard').directive('claimList', [
  'ClaimFlagService',
  'GlobalDataService',
  function (ClaimFlagService, GlobalDataService) {
    return {
      restrict: 'E',
      scope: {
        events: '=',
      },
      templateUrl: '/assets/templates/claim-list.html',
      link: function (scope) {
        scope.claimFlagService = ClaimFlagService;
        scope.globalDataService = GlobalDataService;

        scope.rowClick = function (claim, $event) {
          $event.stopPropagation();
          var selection = window.getSelection();
          if (! selection.isCollapsed) {
            return;
          }
          GlobalDataService.openClaimDetail(claim);
        };

        scope.tableSortClick = function (column) {
          var ascending = GlobalDataService.sortAscending;
          if (column === GlobalDataService.sortColumn) {
            ascending = ! ascending;
          }
          GlobalDataService.setSort(column,  ascending);
        };
      }
    };
  }
]);
