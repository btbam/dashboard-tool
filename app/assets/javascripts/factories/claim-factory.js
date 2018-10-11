'use strict';

angular.module('Dashboard').factory('ClaimFactory', [
  '$resource',
  function ($resource) {
    return $resource('/api/claims/');
  }
]);
