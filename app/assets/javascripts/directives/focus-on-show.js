'use strict';

angular.module('Dashboard').directive('focusOnShow', [
  '$timeout',
  function ($timeout) {
    return {
      restrict: 'A',
      link: function ($scope, $element, $attr) {
        if ($attr.ngShow) {
          $scope.$watch($attr.ngShow, function (newValue) {
            if (newValue) {
              $timeout(function () {
                $element[0].focus();
              }, 0);	
            }
          });      
        }
      }
    };
  }
]);
