'use strict';

angular.module('Dashboard').filter('claimFilterFlag', [
  function() {
    return function (claims, flagType) {
      return _.filter(claims, function(claim) {
        if (claim.force_closed) {
          return false;
        }
        return _.find(claim.flags, function(flag) {
          return flag.type === flagType;
        });
      });
    };
  }
]);
