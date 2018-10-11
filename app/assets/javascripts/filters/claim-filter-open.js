'use strict';

angular.module('Dashboard').filter('claimFilterOpen', [
  function() {
    return function (claims) {
      return _.filter(claims, function(claim) {
        return claim.hasOwnProperty('force_closed') && ! claim.force_closed;
      });
    };
  }
]);
