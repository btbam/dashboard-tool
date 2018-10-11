(function(angular) {
'use strict';

/**
 * @ngdoc overview
 * @name angulartics.heap
 * Enables analytics support for Heap (http://heapanalytics.com)
 */
angular.module('angulartics.heap', ['angulartics'])
.config(['$analyticsProvider', function ($analyticsProvider) {
  

  $analyticsProvider.registerSetUserProperties(function (properties) {
    try {
      heap.identify(properties);
    }
    catch (error) {}
  });
  
  $analyticsProvider.registerPageTrack(function (path) {
    try {
      heap.track('Page Viewed', { 'page': path } );
    }
    catch (error) {}
  });
  
  $analyticsProvider.registerEventTrack(function (action, properties) {
    try {
      heap.track(action, properties);
    }
    catch (error) {}
  });

}]);
})(angular);
