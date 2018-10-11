'use strict';

angular.module('Dashboard').factory('DetailFactory', [
  '$resource',
  function($resource){
    return $resource('/api/claims/:id/detail');
  }
]);
