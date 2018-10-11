'use strict';

angular.module('Dashboard').directive('hideAfter', [
  '$timeout',
  function($timeout){
    return {
      restrict: 'A',
      scope: {
        hideAfter: '@'
      },
      link: function(scope, elem){
        $timeout(function(){
          elem.css('display', 'none');
        }, parseInt(scope.hideAfter));
      }
    };
  }
]);