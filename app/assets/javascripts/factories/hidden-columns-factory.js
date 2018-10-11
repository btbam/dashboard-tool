'use strict';

angular.module('Dashboard').factory('HiddenColumnsFactory', [
  '$resource',
  function($resource){
   return $resource('/api/hidden_columns/:id', null, { update: { method: 'PUT' } });
  }
]);
