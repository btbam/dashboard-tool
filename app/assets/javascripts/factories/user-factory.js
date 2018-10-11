'use strict';

angular.module('Dashboard').factory('UserFactory', [
  '$resource',
  function ($resource) {
    return $resource('/api/users/me');
  }
]);
