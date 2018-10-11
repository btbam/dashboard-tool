'use strict';

angular.module('Dashboard').directive('sidebar', [
  'ClaimNoteService',
  'GlobalDataService',
  'NoteSeverityService',
  function (ClaimNoteService, GlobalDataService, NoteSeverityService) {
    return {
      restrict: 'E',
      scope: {
      },
      templateUrl: '/assets/templates/sidebar.html',
      link: function (scope) {
        scope.claimNoteService = ClaimNoteService;
        scope.globalDataService = GlobalDataService;
        scope.noteSeverityService = NoteSeverityService;
      }
    };
}]);
