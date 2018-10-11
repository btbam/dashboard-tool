'use strict';

angular.module('Dashboard').factory('DiaryNoteFactory', [
  '$resource',
  function($resource){
    return $resource(
      '/api/diary_notes/:id',
      null,
      { update: { method: 'PUT' }, delete: {method: 'POST'} }
    );
  }
]);
