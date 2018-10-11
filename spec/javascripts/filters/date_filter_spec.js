'use strict';

describe('cmdate Filter', function() {
  var $filter;

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_$filter_) {
    $filter = _$filter_;
  }));

  it('has a cmdate filter', function () {
      expect($filter('cmdate')).toBeDefined();
  });

  it('should format date', function () {
    var dateStr = 'Mar 25 2015 01:37:14';
    var dateFormatTests = {
      'MMMM d, yyyy H:mma': 'March 25, 2015 1:37AM',
      'medium': 'Mar 25, 2015 1:37:14 AM',
      'short': '3/25/15 1:37 AM',
      'fullDate': 'Wednesday, March 25, 2015',
      'longDate': 'March 25, 2015',
      'mediumDate': 'Mar 25, 2015',
      'shortDate': '3/25/15',
      'mediumTime': '1:37:14 AM',
      'shortTime': '1:37 AM',
      'MM/dd/yy': '03/25/15',
    };

    for (var dateFormat in dateFormatTests) {
      expect($filter('cmdate')(dateStr, dateFormat)).toEqual(dateFormatTests[dateFormat]);
    }
  });
});
