'use strict';

angular.module('Dashboard').directive('contextSwitcher', [
  'AdjustersFactory',
  'ClaimFactory',
  'ErrorHandlerService',
  'GlobalDataService',
  function(AdjustersFactory, ClaimFactory, ErrorHandlerService, GlobalDataService) {
    return {
      restrict: 'EA',
      templateUrl: '/assets/templates/context-switcher.html',
      scope: {},
      link: function(scope) {
        scope.adjusterClaimsShowing = false;
        scope.contextType = 'user';
        scope.globalDataService = GlobalDataService;
        scope.noResults = false;


        scope.getClaims = function (selected) {
          var params = selected ? { dashboard_adjuster_id: selected.id } : {};
          GlobalDataService.loadingClaims = true;
          ClaimFactory.query(params).$promise
            .then(function (result){
              if (selected) {
                scope.adjusterClaimsShowing = true;
              }
              GlobalDataService.buildCalendar(result, true);
              GlobalDataService.closeClaimDetail();
          }).catch(function (error) {
            GlobalDataService.loadingClaims = false;
            ErrorHandlerService.general(error);
          });
        };

        scope.clearSelected = function () {
          scope.asyncSelected = null;
          scope.noResults = false;

          if (scope.adjusterClaimsShowing) {
            scope.getClaims();
            scope.adjusterClaimsShowing = false;
          }
        };

        scope.getAdjusters = function (search) {
          var adjusters = [], params = { adjuster_name: search };
          GlobalDataService.loadingClaims = true;
          return AdjustersFactory.query(params).$promise
            .then(function (result) {
              _.each(result, function (adjuster) {
                adjusters.push({name:adjuster.name, id:adjuster.adjuster_id, role:'adjuster'});
              });
              GlobalDataService.loadingClaims = false;
              return adjusters;
          }).catch(function (error) {
            GlobalDataService.loadingClaims = false;
            ErrorHandlerService.general(error);
          });
        };
      }
    };
  }
]);
