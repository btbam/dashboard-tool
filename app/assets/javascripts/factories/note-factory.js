'use strict';

angular.module('Dashboard').factory('NoteFactory', [
  '$resource',
  function($resource){
    return $resource('/api/notes', null, { update: { method: 'PUT' } });
  }
]);
