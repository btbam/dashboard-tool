'use strict';

angular.module('Dashboard').service('AppHeaderService', [
  function () {
    var self = this;
    self.hideShowMenuVisible = false;

    self.toggleHideShowMenu = function () {
      self.hideShowMenuVisible = ! self.hideShowMenuVisible;
    };
  }
]);
