'use strict';

angular.module('Dashboard').filter('claimFilterNoDueDate', [
  function() {
    return function (claims) {
      return _.filter(claims, function(claim) {
        if (claim.force_closed) {
          return false;
        }
        return (! claim.feature_date || ! claim.feature_date.due);
      });
    };
  }
]);
