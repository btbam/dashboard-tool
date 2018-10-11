'use strict';

describe('claimFilterClosed Filter', function() {
  var $filter;

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_$filter_) {
    $filter = _$filter_;
  }));

  it('has a claimFilterClosed filter', function () {
      expect($filter('claimFilterClosed')).toBeDefined();
  });

  it('should filter closed claims', function () {
    var claims = [
      { claim_id: 1, force_closed: true },
      { claim_id: 2, force_closed: false },
      { claim_id: 3, force_closed: true },
      { claim_id: 4, force_closed: false },
      { claim_id: 5 },
    ];
    var expected = [ 1, 3 ];
    var filtered = $filter('claimFilterClosed')(claims);
    expect(_.pluck(filtered, 'claim_id')).toEqual(expected);    
  });

  it('should not die on empty array', function () {
    var filtered = $filter('claimFilterClosed')([]);
    expect(filtered).toEqual([]);
  });

  it('should not die on scalar', function () {
    var filtered = $filter('claimFilterClosed')('darth vader');
    expect(filtered).toEqual([]);
  });

  it('should not die on hash', function () {
    var filtered = $filter('claimFilterClosed')({ force: true, father: 'vader' });
    expect(filtered).toEqual([]);
  });
});
