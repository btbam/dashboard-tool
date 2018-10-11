'use strict';

angular.module('Dashboard').factory('FeatureDatesFactory', [
  '$resource',
  function ($resource) {
    return $resource('/api/feature_dates/:feature_id', null, { update: { method: 'PUT', isArray: true } });
  }
]);
