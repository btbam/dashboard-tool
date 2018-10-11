'use strict';

angular.module('Dashboard').factory('ClosedFeaturesFactory', [
  '$resource',
  function ($resource) {
    return $resource('/api/closed_features');
  }
]);
