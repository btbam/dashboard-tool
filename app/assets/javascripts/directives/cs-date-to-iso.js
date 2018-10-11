'use strict';

angular.module('Dashboard').directive('csDateToIso', [
  function () {
    var linkFunction = function (scope, element, attrs, ngModelCtrl) {
      ngModelCtrl.$formatters.push(function (datepickerValue) {
        if (datepickerValue) {
          return moment(datepickerValue).startOf('day').toDate();
        }
        return moment().startOf('day').toDate();
      });
    };

    return {
      restrict: 'A',
      require: 'ngModel',
      link: linkFunction
    };
  }
]);
