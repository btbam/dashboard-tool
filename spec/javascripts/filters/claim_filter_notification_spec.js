'use strict';

describe('claimFilterNotification Filter', function () {
  var $filter, claims;

  claims = [
    { claim_id: 1, type: 'new' },
    { claim_id: 2, type: 'notification' },
    { claim_id: 3, type: 'reminder' },
    { claim_id: 4, type: 'future' },
    { claim_id: 5, type: 'notification' },

    { claim_id: 6, force_closed: true, type: 'new' },
    { claim_id: 7, force_closed: true, type: 'notification' },
    { claim_id: 8, force_closed: true, type: 'reminder' },
    { claim_id: 9, force_closed: true, type: 'future' },
    { claim_id: 10, force_closed: true, type: 'new' },
  ];

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_$filter_) {
    $filter = _$filter_;
  }));

  it('has a claimFilterNotification filter', function () {
      expect($filter('claimFilterNotification')).toBeDefined();
  });

  it('should filter claims by notification', function () {
    var filtered = $filter('claimFilterNotification')(claims);
    expect(_.pluck(filtered, 'claim_id')).toEqual([ 2, 5 ]);
  });
});
