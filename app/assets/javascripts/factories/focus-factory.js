'use strict';

angular.module('Dashboard').factory('FocusFactory', ['$timeout', '$window',
  function($timeout, $window) {
    return function(id) {
      $timeout(function() {
        var element = $window.document.getElementById(id);
        if (element) {
          element.focus();
        }
      });
    };
  }
]);
