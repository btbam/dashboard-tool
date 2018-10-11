'use strict';

angular.module('Dashboard').filter('claimFilterNote', [
  function () {
    return function (claims, severity) {
      return _.filter(claims, function (claim) {
        if (claim.force_closed) {
          return false;
        }
        return _.find(claim.flags, function (flag) {
          return flag.type === 'lastnote' && flag.severity === severity;
        });
      });
    };
  }
]);
