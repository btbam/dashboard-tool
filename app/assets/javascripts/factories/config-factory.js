'use strict';

angular.module('Dashboard').factory('ConfigFactory', [
  '$resource',
  function ($resource) {
    return $resource('/api/config/');
  }
]);
