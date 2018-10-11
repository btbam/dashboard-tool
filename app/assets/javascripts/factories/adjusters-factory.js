'use strict';

angular.module('Dashboard').factory('AdjustersFactory', [
  '$resource',
  function ($resource) {
    return $resource('/api/adjusters');
  }
]);
