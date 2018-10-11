'use strict';

describe('claimFilterDay Filter', function() {
  var $filter, claims, futureDate1, futureDate2, pastDate1, pastDate2;

  futureDate1 = new moment().add(100, 'days').startOf('day');
  futureDate2 = new moment().add(69, 'days').startOf('day');
  pastDate1 = new moment().subtract(300, 'days').startOf('day');
  pastDate2 = new moment().subtract(42, 'days').startOf('day');

  claims = [
    { claim_id: 1, feature_date: { due: futureDate1.format('YYYY-MM-DD') } },
    { claim_id: 2, feature_date: { due: futureDate1.format('YYYY-MM-DD') } },
    { claim_id: 3, feature_date: { due: futureDate2.format('YYYY-MM-DD') }, force_closed: true },
    { claim_id: 4, feature_date: { due: futureDate2.format('YYYY-MM-DD') } },
    { claim_id: 5, feature_date: { due: pastDate1.format('YYYY-MM-DD') } },
    { claim_id: 6, feature_date: { due: pastDate2.format('YYYY-MM-DD') } },
    { claim_id: 7 },
    { claim_id: 8, feature_date: { } },
  ];

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_$filter_) {
    $filter = _$filter_;
  }));

  it('has a claimFilterDay filter', function () {
      expect($filter('claimFilterDay')).toBeDefined();
  });

  it('should filter claims by day', function () {
    var filtered;

    filtered = $filter('claimFilterDay')(claims, futureDate1.toDate());
    expect(_.pluck(filtered, 'claim_id')).toEqual([ 1, 2 ]);

    filtered = $filter('claimFilterDay')(claims, futureDate2.toDate());
    expect(_.pluck(filtered, 'claim_id')).toEqual([ 4 ]);

    filtered = $filter('claimFilterDay')(claims, pastDate1.toDate());
    expect(_.pluck(filtered, 'claim_id')).toEqual([ 5 ]);

    filtered = $filter('claimFilterDay')(claims, pastDate2.toDate());
    expect(_.pluck(filtered, 'claim_id')).toEqual([ 6 ]);

    filtered = $filter('claimFilterDay')(claims, new Date());
    expect(_.pluck(filtered, 'claim_id')).toEqual([ ]);
  });
});
