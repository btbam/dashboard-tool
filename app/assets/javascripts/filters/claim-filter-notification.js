'use strict';

angular.module('Dashboard').filter('claimFilterNotification', [
  function() {
    return function (claims) {
      return _.filter(claims, function(claim) {
        return ! claim.force_closed && claim.type === 'notification';
      });
    };
  }
]);
