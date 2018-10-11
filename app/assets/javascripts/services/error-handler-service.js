'use strict';

angular.module('Dashboard').service('ErrorHandlerService', [function () {
  this.general = function (error, noAlert) {
    console.log('General Error');
    if (error) {
      console.log(error);
    }
    if (! noAlert) {
      alert('An error has occurred. Please try again or reload the page.');
    }
  };
}]);
