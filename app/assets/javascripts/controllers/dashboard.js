'use strict';

angular.module('Dashboard').controller('DashboardCtrl', [
  '$q',
  '$scope',
  'ClaimFactory',
  'ConfigFactory',
  'ErrorHandlerService',
  'GlobalDataService',
  'UserFactory',
  function($q, $scope, ClaimFactory, ConfigFactory, ErrorHandlerService, GlobalDataService, UserFactory) {
    var self = this;
    self.globalDataService = GlobalDataService;

    $q.all([
      ConfigFactory.get().$promise,
      ClaimFactory.query().$promise,
      UserFactory.get().$promise
    ]).then(function (result) {
      GlobalDataService.flagsVisible = result[0].flags_visible;
      GlobalDataService.user = result[2];
      GlobalDataService.setClaimColumns();

      GlobalDataService.buildCalendar(result[1], true);
      GlobalDataService.loadingApp = false;

    }, ErrorHandlerService.general);
  }
]);
