'use strict';

angular.module('Dashboard').filter('claimFilterReminder', [
  function() {
    return function (claims, activeFilter) {
      return _.filter(claims, function(claim) {
        if (claim.force_closed) {
          return false;
        }
        if (activeFilter === 'reminder' && _.contains(['call', 'email', 'follow-up'], claim.type)) {
          return true;
        }
        return claim.type === activeFilter;
      });
    };
  }
]);
