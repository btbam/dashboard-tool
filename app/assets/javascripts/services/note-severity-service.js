'use strict';

angular.module('Dashboard').service('NoteSeverityService', [

  function () {
    var self = this;

    self.breakpoints = {
      month: { low: 0, 'med-low': 31, med: 61, high: 91 },
      week: { low: 0, 'med-low': 8, med: 15, high: 31 },
    };

    self.buckets = {
      'month': {
        'low': [
          { min: 0, max: 5 }, { min: 6, max: 10 }, { min: 11, max: 15 },
          { min: 16, max: 20 }, { min: 21, max: 25 }, { min: 26, max: 30 }
        ],
        'med-low': [
          { min: 31, max: 35 }, { min: 36, max: 40 }, { min: 41, max: 45 },
          { min: 46, max: 50 }, { min: 51, max: 55 }, { min: 56, max: 60 }
        ],
        'med': [
          { min: 61, max: 65 }, { min: 66, max: 70 }, { min: 71, max: 75 },
          { min: 76, max: 80 }, { min: 81, max: 85 }, { min: 86, max: 90 }
        ],
        'high': [
          { min: 91, max: 95 }, { min: 96, max: 100 }, { min: 101, max: 105 },
          { min: 106, max: 110 }, { min: 111, max: 115 }, { min: 116, max: 120 }
        ],
      },
      'week': {
        'low': [
          { min: 0, max: 1 }, { min: 2, max: 2 }, { min: 3, max: 3 },
          { min: 4, max: 4 }, { min: 5, max: 5 }, { min: 6, max: 6 }, { min: 7, max: 7 }
        ],
        'med-low': [
          { min: 8, max: 8 }, { min: 9, max: 9 }, { min: 10, max: 10 },
          { min: 11, max: 11 }, { min: 12, max: 12 }, { min: 13, max: 13 }, { min: 14, max: 14 }
        ],
        'med': [
          { min: 15, max: 16 }, { min: 17, max: 18 }, { min: 19, max: 20 },
          { min: 21, max: 22 }, { min: 23, max: 24 }, { min: 25, max: 26 }, { min: 27, max: 30 }
        ],
        'high': [
          { min: 31, max: 35 }, { min: 36, max: 40 }, { min: 41, max: 45 },
          { min: 46, max: 50 }, { min: 51, max: 55 }, { min: 56, max: 60 }
        ],
      }
    };

    self.labels = {
      month: { low: '0-30', 'med-low': '31-60', med: '61-90', high: '91+' },
      week: { low: '0-7', 'med-low': '8-14', med: '15-30', high: '31+' },
    };

    self.xMax = {
      month: { low: 30, 'med-low': 60, med: 90, high: 120 },
      week: { low: 7, 'med-low': 14, med: 30, high: 60 },
    };

    self.xMin = {
      month: { low: 0, 'med-low': 30, med: 60, high: 90 },
      week: { low: 0, 'med-low': 7, med: 14, high: 30 },
    };

    self.breakpoint = function (timeFrame, severity) {
      timeFrame = self.fixString(timeFrame);
      severity = self.fixString(severity);
      if (self.breakpoints[timeFrame] && self.breakpoints[timeFrame][severity]) {
        return parseInt(self.breakpoints[timeFrame][severity]);
      }
      return 0;
    };

    self.fixString = function (str) {
      return str ? str.toLowerCase() : '';
    };

    self.label = function (timeFrame, severity) {
      timeFrame = self.fixString(timeFrame);
      severity = self.fixString(severity);
      if (self.labels[timeFrame] && self.labels[timeFrame][severity]) {
        return self.labels[timeFrame][severity];
      }
      return '';
    };

    self.severity = function (timeFrame, days) {
      timeFrame = self.fixString(timeFrame);
      if (days === undefined) {
        return;
      }
      else if (days >= self.breakpoint(timeFrame, 'high')) {
        return 'high';
      }
      else if (days >= self.breakpoint(timeFrame, 'med')) {
        return 'med';
      }
      else if (days >= self.breakpoint(timeFrame, 'med-low')) {
        return 'med-low';
      }
      return 'low';
    };

    self.xmax = function (timeFrame, severity) {
      timeFrame = self.fixString(timeFrame);
      severity = self.fixString(severity);
      if (self.xMax[timeFrame] && self.xMax[timeFrame][severity]) {
        return self.xMax[timeFrame][severity];
      }
      return 0;
    };

    self.xmin = function (timeFrame, severity) {
      timeFrame = self.fixString(timeFrame);
      severity = self.fixString(severity);
      if (self.xMin[timeFrame] && self.xMin[timeFrame][severity]) {
        return self.xMin[timeFrame][severity];
      }
      return 0;
    };
  }
]);
