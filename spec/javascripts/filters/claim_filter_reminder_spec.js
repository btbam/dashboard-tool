'use strict';

describe('claimFilterReminder Filter', function () {
  var $filter, claims;
  
  claims = [
    { claim_id: 1, type: 'email' },
    { claim_id: 2, type: 'call' },
    { claim_id: 3, type: 'email' },
    { claim_id: 4, type: 'follow-up' },
    { claim_id: 5, type: 'call' },
    { claim_id: 6, type: 'call' },
    { claim_id: 7, type: 'email' },
    { claim_id: 8, type: 'follow-up' },

    { claim_id: 1, force_closed: true, type: 'email' },
    { claim_id: 2, force_closed: true, type: 'call' },
    { claim_id: 3, force_closed: true, type: 'email' },
    { claim_id: 4, force_closed: true, type: 'follow-up' },
    { claim_id: 5, force_closed: true, type: 'call' },
    { claim_id: 6, force_closed: true, type: 'call' },
    { claim_id: 7, force_closed: true, type: 'email' },
    { claim_id: 8, force_closed: true, type: 'follow-up' },
  ];

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_$filter_) {
    $filter = _$filter_;
  }));

  it('has a claimFilterReminder filter', function () {
      expect($filter('claimFilterReminder')()).toBeDefined();
  });

  it('should filter by call', function () {
    var filteredClaims = $filter('claimFilterReminder')(claims, 'call');
    expect(_.pluck(filteredClaims, 'claim_id')).toEqual([ 2, 5, 6 ]);
  });

  it('should filter by email', function () {
    var filteredClaims = $filter('claimFilterReminder')(claims, 'email');
    expect(_.pluck(filteredClaims, 'claim_id')).toEqual([ 1, 3, 7 ]);
  });

  it('should filter by follow-up', function () {
    var filteredClaims = $filter('claimFilterReminder')(claims, 'follow-up');
    expect(_.pluck(filteredClaims, 'claim_id')).toEqual([ 4, 8 ]);
  });
});
