'use strict';

angular.module('Dashboard').service('ClaimFlagService', [
  function () {
    var self = this;

    self.canShowFlag = function (flag) {
      if (flag.type !== 'lastnote') {
        return true;
      }
      return flag.severity === 'high' || flag.severity === 'med';
    };

    self.claimFlagCount  = function (claim) {
      if (! claim.flags || ! claim.flags.length) {
        return 0;
      }
      var flagCount = _.filter(claim.flags, function (flag) {
        return self.canShowFlag(flag);
      }).length;
      return flagCount > 4 ? 5 : flagCount;
    };

    self.claimFlagDisputed = function (claim, flagType) {
      return _.find(claim.flags, function (flag) {
        return flag.type === flagType && flag.disputed;
      });
    };

    self.claimHasFlag = function (claim, flagType, flagSeverity) {
      return _.find(claim.flags, function (flag) {
        return flag.type === flagType && (! flagSeverity || flag.severity === flagSeverity);
      });
    };

    self.disputeFlag = function (claim, flagType) {
      var flag = _.find(claim.flags, function (flag) {
        return flag.type === flagType;
      });
      if (flag) {
        flag.disputed = true;
      }
    };
  }
]);
