'use strict';

angular.module('Dashboard', [
  'angular-click-outside',
  'angulartics',
  'angulartics.heap',
  'countTo',
  'ngResource',
  'ngSanitize',
  'ui.bootstrap'
]);

angular.module('Dashboard').run([
  '$http',
  '$rootScope',
  function($http, $rootScope){
    $http.get('/monitoring/alerts').success(function(data){
      $rootScope.alertMessages = data;
    });
  }
]);
