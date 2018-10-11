'use strict';

angular.module('Dashboard').filter('claimFilterDay', [
  function() {
    return function (claims, day) {
      return _.filter(claims, function(claim) {
        var due = moment(new Date()).startOf('day');

        if (claim.force_closed) {
          return false;
        }

        if (claim.feature_date && claim.feature_date.due) {
          due =  moment(claim.feature_date.due).startOf('day');
        }

        if (claim.feature_date && claim.feature_date.due) {
          return moment(day).isSame(due, 'day');
        }
      });
    };
  }
]);
