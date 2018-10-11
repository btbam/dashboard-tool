'use strict';

describe('claimFilterOpen Filter', function() {
  var $filter;

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_$filter_) {
    $filter = _$filter_;
  }));

  it('has a claimFilterOpen filter', function () {
      expect($filter('claimFilterOpen')).toBeDefined();
  });

  it('should filter open claims', function () {
    var claims = [
      { claim_id: 1, force_closed: true },
      { claim_id: 2, force_closed: false },
      { claim_id: 3, force_closed: true },
      { claim_id: 4, force_closed: false },
      { claim_id: 5, force_closed: false },
      { bogus: 'sausage' }
    ];
    var expected = [ 2, 4, 5];
    var filtered = $filter('claimFilterOpen')(claims);
    expect(_.pluck(filtered, 'claim_id')).toEqual(expected);    
  });

  it('should not die on empty array', function () {
    var filtered = $filter('claimFilterOpen')([]);
    expect(filtered).toEqual([]);
  });

  it('should not die on scalar', function () {
    var filtered = $filter('claimFilterOpen')('darth vader');
    expect(filtered).toEqual([]);
  });

  it('should not die on hash', function () {
    var filtered = $filter('claimFilterOpen')({ force: true, father: 'vader' });
    expect(filtered).toEqual([]);
  });
});
