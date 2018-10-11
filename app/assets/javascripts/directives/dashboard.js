'use strict';

angular.module('Dashboard').directive('dashboard', [
  'ClaimNoteService',
  'ClaimsService',
  'GlobalDataService',
  'NoteSeverityService',
  function (ClaimNoteService, ClaimsService, GlobalDataService, NoteSeverityService) {
    return {
      restrict: 'E',
      scope: {},
      templateUrl: '/assets/templates/dashboard.html',
      link: function (scope) {
        scope.claimNoteService = ClaimNoteService;
        scope.claimsService = ClaimsService;
        scope.globalDataService = GlobalDataService;
        scope.noteSeverityService = NoteSeverityService;
      }
    };
}]);
