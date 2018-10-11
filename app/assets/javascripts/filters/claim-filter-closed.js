'use strict';

angular.module('Dashboard').filter('claimFilterClosed', [
  function() {
    return function (claims) {
      return _.filter(claims, function(claim) {
        return claim.force_closed;
      });
    };
  }
]);
