'use strict';

angular.module('Dashboard').filter('claimFilterPastDue', [
  function() {
    return function (claims) {
      return _.filter(claims, function(claim) {
        var today = moment(new Date()).startOf('day');

        if (claim.force_closed) {
          return false;
        }

        if (claim.feature_date && claim.feature_date.due &&
          moment(claim.feature_date.due).startOf('day').isBefore(today, 'day')) {
          return true;
        }
      });
    };
  }
]);
