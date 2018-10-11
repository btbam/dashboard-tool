'use strict';

describe('claimFilterNote Filter', function() {
  var $filter, claims, pastDate1, pastDate2, pastDate3, pastDate4, filteredClaims, ClaimsService;
  
  pastDate1 = new moment().subtract(20, 'days').startOf('day');
  pastDate2 = new moment().subtract(40, 'days').startOf('day');
  pastDate3 = new moment().subtract(70, 'days').startOf('day');
  pastDate4 = new moment().subtract(200, 'days').startOf('day');

  claims = [
    { claim_id: 1, last_adjuster_note: { dashboard_updated_at: pastDate1.format('YYYY-MM-DD') } },
    { claim_id: 2, last_adjuster_note: { dashboard_updated_at: pastDate2.format('YYYY-MM-DD') } },
    { claim_id: 3, last_adjuster_note: { dashboard_updated_at: pastDate3.format('YYYY-MM-DD') } },
    { claim_id: 4, last_adjuster_note: { dashboard_updated_at: pastDate4.format('YYYY-MM-DD') } },

    { claim_id: 5, force_closed: true, last_manager_note: { dashboard_updated_at: pastDate1.format('YYYY-MM-DD') } },
    { claim_id: 6, force_closed: true, last_manager_note: { dashboard_updated_at: pastDate2.format('YYYY-MM-DD') } },
    { claim_id: 7, force_closed: true, last_manager_note: { dashboard_updated_at: pastDate3.format('YYYY-MM-DD') } },
    { claim_id: 8, force_closed: true, last_manager_note: { dashboard_updated_at: pastDate4.format('YYYY-MM-DD') } },

    { claim_id: 9, notes: [] },
    { claim_id: 10 },
  ];

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_$filter_, _ClaimsService_) {
    $filter = _$filter_;
    ClaimsService = _ClaimsService_;
    ClaimsService.setLastNoteFlags(claims);
  }));

  it('has a claimFilterNote filter', function () {
      expect($filter('claimFilterNote')()).toBeDefined();
  });

  it('should filter on lastnote-low', function () {
    filteredClaims = $filter('claimFilterNote')(claims, 'low')
    expect(_.pluck(filteredClaims, 'claim_id')).toEqual([ 1, 9, 10 ]);
  });

  it('should filter on lastnote-med-low', function () {
    filteredClaims = $filter('claimFilterNote')(claims, 'med-low')
    expect(_.pluck(filteredClaims, 'claim_id')).toEqual([ 2 ]);
  });

  it('should filter on lastnote-med', function () {
    filteredClaims = $filter('claimFilterNote')(claims, 'med')
    expect(_.pluck(filteredClaims, 'claim_id')).toEqual([ 3 ]);
  });

  it('should filter on lastnote-high', function () {
    filteredClaims = $filter('claimFilterNote')(claims, 'high')
    expect(_.pluck(filteredClaims, 'claim_id')).toEqual([ 4 ]);
  });
});
