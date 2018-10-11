'use strict';

describe('claimFilterFlag Filter', function() {
  var $filter, claims;

  claims = [
    { claim_id: 1 },
    { claim_id: 2, flags: [ ] },
    { claim_id: 3, flags: [ { type: 'touch' } ] },
    { claim_id: 4, flags: [ { type: 'duration' } ] },
    { claim_id: 5, flags: [ { type: 'future-flag' } ] },
    { claim_id: 6, flags: [ { type: 'touch' }, { type: 'duration' } ] },
    { claim_id: 7, flags: [ { type: 'touch' }, { type: 'future-flag' } ] },
    { claim_id: 8, flags: [ { type: 'duration' }, { type: 'future-flag' } ] },
    { claim_id: 9, flags: [ { type: 'duration' }, { type: 'touch' }, { type: 'future-flag' } ] },

    { claim_id: 10, force_closed: true },
    { claim_id: 11, force_closed: true, flags: [ ] },
    { claim_id: 12, force_closed: true, flags: [ { type: 'touch' } ] },
    { claim_id: 13, force_closed: true, flags: [ { type: 'duration' } ] },
    { claim_id: 14, force_closed: true, flags: [ { type: 'future-flag' } ] },
    { claim_id: 15, force_closed: true, flags: [ { type: 'touch' }, { type: 'duration' } ] },
    { claim_id: 16, force_closed: true, flags: [ { type: 'touch' }, { type: 'future-flag' } ] },
    { claim_id: 17, force_closed: true, flags: [ { type: 'duration' }, { type: 'future-flag' } ] },
    { claim_id: 18, force_closed: true, flags: [ { type: 'duration' }, { type: 'touch' }, { type: 'future-flag' } ] },
  ];

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_$filter_) {
    $filter = _$filter_;
  }));

  it('has a claimFilterFlag filter', function () {
      expect($filter('claimFilterFlag')).toBeDefined();
  });

  it('should filter claims by touch flag', function () {
    var filtered = $filter('claimFilterFlag')(claims, 'touch');
    expect(_.pluck(filtered, 'claim_id')).toEqual([ 3, 6, 7, 9 ]);
  });

  it('should filter claims by duration flag', function () {
    var filtered = $filter('claimFilterFlag')(claims, 'duration');
    expect(_.pluck(filtered, 'claim_id')).toEqual([ 4, 6, 8, 9 ]);
  });

  it('should filter claims by future flag', function () {
    var filtered = $filter('claimFilterFlag')(claims, 'future-flag');
    expect(_.pluck(filtered, 'claim_id')).toEqual([ 5, 7, 8, 9 ]);
  });

  it('should filter claims by non-existent flag', function () {
    var filtered = $filter('claimFilterFlag')(claims, 'my-sex-life');
    expect(_.pluck(filtered, 'claim_id')).toEqual([ ]);
  });
});
