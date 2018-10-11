'use strict';

angular.module('Dashboard').filter('claimFilterNew', [
  function () {
    return function (claims) {
      return _.filter(claims, function (claim) {
        return ! claim.force_closed && claim.type === 'new';
      });
    };
  }
]);
