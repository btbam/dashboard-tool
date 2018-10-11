'use strict';

describe('Claims Service', function () {
  var claims, claimsResponse, futureDate1, futureDate2,
    http, mockClaimsWithDaysSinceLastNote, pastDate1, pastDate2, scope, today,
    Claim, ClaimNoteService, ClaimService, ClaimsService, GlobalDataService, user;

  futureDate1 = new moment().add(100, 'days').startOf('day');
  futureDate2 = new moment().add(69, 'days').startOf('day');
  pastDate1 = new moment().subtract(300, 'days').startOf('day');
  pastDate2 = new moment().subtract(42, 'days').startOf('day');
  today = new moment().startOf('day');
  user = {id: 1, is_manager: false, is_adjuster: true };

  claimsResponse = [
    { claim_id: 111, notifications: [ 1, 2, 3 ], litigation: 'hell yeah', force_closed: false,
      notes: [ { dashboard_updated_at: pastDate1.toDate() } ], flags: [ { type: 'duration' }],
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Sabina' } },
      last_adjuster_note: { dashboard_updated_at: pastDate1.toDate() },
      'adjuster_name': 'Beavis', state: 'Alabama', claimant_name: 'Quinn',
      total_reserve: 12, total_outstanding: 45, indemnity_outstanding: 16, medical_outstanding: 33, legal_outstanding: 9,
      feature_date: { due: futureDate1.toDate() }, feature_created: pastDate1.toDate()
    },

    { claim_id: 222, notifications: [ 1, 2, 3 ], notes: [ { dashboard_updated_at: pastDate2.toDate() } ],
      flags: [ { type: 'touch' }], 'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'David' } },
      last_adjuster_note: { dashboard_updated_at: pastDate1.toDate() }, 'adjuster_name': 'Butthead',
      state: 'Oregon', claimant_name: 'Justin', total_reserve: 66, total_outstanding: 500,
      indemnity_outstanding: 999, medical_outstanding: 22.5, legal_outstanding: 1, force_closed: false,
      feature_date: { }, feature_created: pastDate1.toDate()
    },

    { claim_id: 333, feature_date: { due: futureDate1.toDate() }, notes: [],
      flags: [ { type: 'duration' }], diary_notes: [ { diary_note_types: ['email'] } ],
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Thoreau' }},
      state: 'California', last_adjuster_note: { dashboard_updated_at: pastDate2.toDate() }, 'adjuster_name': 'Allison',
      claimant_name: 'Lily', total_reserve: 199, total_outstanding: 4, indemnity_outstanding: 6,
      medical_outstanding: 3, legal_outstanding: 999, force_closed: false,
      feature_created: pastDate2.toDate()
    },

    { claim_id: 444, feature_date: { due: futureDate2.toDate() }, notes: [],
      flags: [ { type: 'touch' }], diary_notes: [ { diary_note_types: ['follow-up'] } ],
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Henry' } },
      'adjuster_name': 'Roger', state: 'Texas', claimant_name: 'Fred',
      total_reserve: 1, total_outstanding: 4.5, indemnity_outstanding: 666, medical_outstanding: 100,
      legal_outstanding: 9999, force_closed: false, feature_created: pastDate1.toDate()
    },

    { claim_id: 555, feature_date: { due: futureDate2.toDate() }, notes: [],
      flags: [ { type: 'touch' }], diary_notes: [ { diary_note_types: ['follow-up'] } ],
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Reginald' }},
      'adjuster_name': 'David', state: 'Idaho', claimant_name: 'Jesus',
      total_reserve: 1000, total_outstanding: 45000, indemnity_outstanding: 16000, medical_outstanding: 3.3,
      legal_outstanding: 1239.12, force_closed: false, feature_created: pastDate2.toDate()
    },

    { claim_id: 666, feature_date: { due: pastDate1.toDate() },
      notes: [], diary_notes: [ { diary_note_types: ['email'] } ],
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Jennifer' } },
      'adjuster_name': 'Stephen', state: 'Colorado', claimant_name: 'Trump',
      total_reserve: 0, total_outstanding: 93, indemnity_outstanding: 373, medical_outstanding: 123.3,
      legal_outstanding: 12.39, force_closed: false, feature_created: pastDate1.toDate()
    },

    { claim_id: 777, feature_date: { due: pastDate2.toDate() },
      notes: [], diary_notes: [ { diary_note_types: ['call'] } ], dashboard_compound_key: 'dambeaver',
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Dick' }}, litigation: 'yeah',
      'adjuster_name': 'Roadrunner', state: 'New York', claimant_name: 'Buckethead', total_reserve: 1000,
      total_outstanding: 450, indemnity_outstanding: 160, medical_outstanding: 99993.3,
      legal_outstanding: 123922.12, force_closed: false, feature_created: pastDate2.toDate()
    },

    { claim_id: 888, notes: [], dashboard_compound_key: 'beaverlove', state: 'Nevada',
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Mo' } }, 'adjuster_name': 'Elvis',
      claimant_name: 'Tony', total_reserve: 100, total_outstanding: 937, indemnity_outstanding: 94.44,
      medical_outstanding: 6482, legal_outstanding: 9371, force_closed: false,
      feature_date: { due: futureDate1.toDate() }, feature_created: pastDate1.toDate()
    },

    { claim_id: 999, force_closed: true, feature_date: { due: today.toDate() },
      notes: [], 'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Nancy' } },
      'adjuster_name': 'Anie', state: 'Missouri', claimant_name: 'Bert',
      total_reserve: 8, total_outstanding: 7, indemnity_outstanding: 1008, medical_outstanding: 123.3,
      legal_outstanding: 123.55, feature_created: pastDate2.toDate()
   },
  ];

  mockClaimsWithDaysSinceLastNote = [
    { },
    { daysSinceLastNote: 1 },
    { daysSinceLastNote: 2 },
    { daysSinceLastNote: 4 },
    { daysSinceLastNote: 6 },
    { daysSinceLastNote: 11 },
    { daysSinceLastNote: 12 },
    { daysSinceLastNote: 99 },
    { daysSinceLastNote: 100 },
  ];
  beforeEach(module('Dashboard'));

  beforeEach(inject(function ($httpBackend, $rootScope, _ClaimFactory_, _ClaimNoteService_,
    _ClaimService_, _ClaimsService_, _GlobalDataService_) {

    scope = $rootScope.$new();
    Claim = _ClaimFactory_;
    ClaimNoteService = _ClaimNoteService_;
    ClaimService = _ClaimService_;
    ClaimsService = _ClaimsService_;
    GlobalDataService = _GlobalDataService_;

    http = $httpBackend;
    http.when('GET', '/monitoring/alerts').respond([]);
    http.when('GET', '/api/claims').respond(claimsResponse);
    http.when('GET', '/api/users/me').respond({ is_manager: false, is_adjuster: true });
    http.when('GET', '/api/hidden_columns').respond();

    claims = Claim.query();
    scope.$digest();
    http.flush();
    ClaimsService.setLastNoteFlags(claims);
    ClaimsService.updateClaims(claims, user);
  }));

  it('should calculate claim event counts', function () {
    var expectedClaimCounts = {};
    expectedClaimCounts[futureDate1.format('YYYYMMDD')] = 3;
    expectedClaimCounts[futureDate2.format('YYYYMMDD')] = 2;
    expectedClaimCounts[pastDate1.format('YYYYMMDD')] = 1
    expectedClaimCounts[pastDate2.format('YYYYMMDD')] = 1

    expect(ClaimsService.claimEventCounts(claims)).toEqual(expectedClaimCounts);
  });

  it('should return claim filter counts', function () {
    var expectedClaimFilterCounts = { 'call': 1, 'email': 2, 'follow-up': 2, 'new': 3,
      'notification': 0, 'open': 8, 'duration': 2, 'touch': 3, 'lastnote-low': 0, 'no-due-date': 1,
      'lastnote-med-low': 3, 'lastnote-med': 0, 'lastnote-high': 5, 'closed': 1, 'past-due': 2
    };
    expect(ClaimsService.claimFilterCounts(claims)).toEqual(expectedClaimFilterCounts);
  });

  it('should set days since last note', function () {
    var expected = [ 300, 300, 42, 300, 42, 300, 42, 300, 42 ];
    _.each(claims, function (claim) {
      expect(claim.daysSinceLastNote).toBeUndefined();
    });
    ClaimsService.setDaysSinceLastNote(claims);
    expect(_.pluck(claims, 'daysSinceLastNote')).toEqual(expected)
  });

  it('should return days since last note bucket counts', function () {
    var expectedMonth = {
        'low': [ 3, 1, 2, 0, 0, 0 ],
        'med-low': [ 0, 0, 0, 0, 0, 0 ],
        'med': [ 0, 0, 0, 0, 0, 0 ],
        'high': [ 0, 2, 0, 0, 0, 0 ]
      },
      expectedWeek = {
        'low': [ 1, 1, 0, 1, 0, 1, 0 ],
        'med-low': [ 0, 0, 0, 1, 1, 0, 0 ],
        'med': [ 0, 0, 0, 0, 0, 0, 0 ],
        'high': [ 0, 0, 0, 0, 0, 0 ]
      };

    ClaimNoteService.lastNoteTimeFrame = 'month';
    expect(ClaimsService.daysSinceLastNoteBucketCounts(mockClaimsWithDaysSinceLastNote)).toEqual(expectedMonth);

    ClaimNoteService.lastNoteTimeFrame = 'week';
    expect(ClaimsService.daysSinceLastNoteBucketCounts(mockClaimsWithDaysSinceLastNote)).toEqual(expectedWeek)
  });

  it('should return due today count', function () {
    expect(ClaimsService.dueTodayCount(claims)).toBe(0);
  });

  it('should filter claims', function () {
    expect(ClaimsService.filterClaims(claims, 'new').length).toBe(3);
    expect(ClaimsService.filterClaims(claims, 'diary').length).toBe(0);
    expect(ClaimsService.filterClaims(claims, 'call').length).toBe(1);
    expect(ClaimsService.filterClaims(claims, 'email').length).toBe(2);
    expect(ClaimsService.filterClaims(claims, 'follow-up').length).toBe(2);
    expect(ClaimsService.filterClaims(claims, 'notification').length).toBe(0);
    expect(ClaimsService.filterClaims(claims, 'touch').length).toBe(3);
    expect(ClaimsService.filterClaims(claims, 'duration').length).toBe(2);
    expect(ClaimsService.filterClaims(claims, 'lastnote').length).toBe(8);
    expect(ClaimsService.filterClaims(claims, 'lastnote-low').length).toBe(0);
    expect(ClaimsService.filterClaims(claims, 'lastnote-med-low').length).toBe(3);
    expect(ClaimsService.filterClaims(claims, 'lastnote-med').length).toBe(0);
    expect(ClaimsService.filterClaims(claims, 'lastnote-high').length).toBe(5);
    expect(ClaimsService.filterClaims(claims, 'day', futureDate1.toDate()).length).toBe(3);
    expect(ClaimsService.filterClaims(claims, 'day', futureDate2.toDate()).length).toBe(2);
    expect(ClaimsService.filterClaims(claims, 'search', '', 'beaver').length).toBe(2);
    expect(ClaimsService.filterClaims(claims, 'search', '', '333').length).toBe(1);
    expect(ClaimsService.filterClaims(claims, 'closed').length).toBe(1);
    expect(ClaimsService.filterClaims(claims, 'open').length).toBe(8);
    expect(ClaimsService.filterClaims(claims, 'past-due').length).toBe(2);
    expect(ClaimsService.filterClaims(claims, 'no-due-date').length).toBe(1);
    expect(ClaimsService.filterClaims(claims, '').length).toBe(8);
  });

  it('should return days since last note counts', function () {
    expect(ClaimsService.daysSinceLastNoteCount(mockClaimsWithDaysSinceLastNote, 0, 5)).toBe(3);
    expect(ClaimsService.daysSinceLastNoteCount(mockClaimsWithDaysSinceLastNote, 6, 10)).toBe(1);
    expect(ClaimsService.daysSinceLastNoteCount(mockClaimsWithDaysSinceLastNote, 11, 100)).toBe(4);
    expect(ClaimsService.daysSinceLastNoteCount(mockClaimsWithDaysSinceLastNote, 0, 500)).toBe(8);
    expect(ClaimsService.daysSinceLastNoteCount(mockClaimsWithDaysSinceLastNote, 6, 100)).toBe(5);
  });

  it('should return maxDaysSinceLastNoteBucketCount', function () {
    var bucketCounts;

    ClaimNoteService.lastNoteTimeFrame = 'month';
    bucketCounts = ClaimsService.daysSinceLastNoteBucketCounts(mockClaimsWithDaysSinceLastNote);
    expect(ClaimsService.maxDaysSinceLastNoteBucketCount(bucketCounts)).toBe(3)

    ClaimNoteService.lastNoteTimeFrame = 'week';
    bucketCounts = ClaimsService.daysSinceLastNoteBucketCounts(mockClaimsWithDaysSinceLastNote);
    expect(ClaimsService.maxDaysSinceLastNoteBucketCount(bucketCounts)).toBe(1);
  });

  it('should update claims', function () {
    var processedClaims = ClaimsService.updateClaims(claims, true);
    _.each(processedClaims, function (processedClaim) {
      expect(processedClaim.litigation.length > 0).toBe(true);
      expect(processedClaim.search.length > 0).toBe(true);
    });
  });

  it('should set days since last note', function () {
    var expected = [ 300, 300, 42, 300, 42, 300, 42, 300, 42 ];
    ClaimsService.setDaysSinceLastNote(claims);
    expect(_.pluck(claims, 'daysSinceLastNote')).toEqual(expected);
  });

  it('should set last note flags', function () {
    var expectFlagArray = [
      [ { type: 'duration' }, { type: 'lastnote', severity: 'high' } ],
      [ { type: 'touch' }, { type: 'lastnote', severity: 'high' } ],
      [ { type: 'duration' }, {type: 'lastnote', severity: 'med-low' } ],
      [ { type: 'touch' }, { type: 'lastnote', severity: 'high' } ],
      [ { type: 'touch' }, { type: 'lastnote', severity: 'med-low' } ],
      [ { type: 'lastnote', severity: 'high' } ],
      [ { type: 'lastnote', severity: 'med-low' } ],
      [ { type: 'lastnote', severity: 'high' } ],
      [ { type: 'lastnote', severity: 'med-low' } ],
    ];

    var flagArray = [];
    _.each(claims, function (claim) {
      flagArray.push(claim.flags);
    })

    expect(flagArray).toEqual(expectFlagArray);
  });

  it('should sort claims', function () {
    var sortedClaimIds;
    var expectedSortedClaimIds = {
      'claim_id': [ 111, 222, 333, 444, 555, 666, 777, 888, 999 ],
      'flags': [ 777, 999, 333, 555, 666, 888, 111, 222, 444 ],
      'age': [ 333, 111, 222, 444, 555, 666, 777, 888, 999 ],
      'litigation': [ 111, 222, 333, 444, 555, 666, 888, 999, 777 ],
      'adjuster': [ 333, 999, 111, 222, 555, 888, 777, 444, 666 ],
      'state': [ 111, 333, 666, 555, 999, 888, 777, 222, 444 ],
      'claimant': [ 999, 777, 444, 555, 222, 333, 111, 888, 666 ],
      'insured': [ 222, 777, 444, 666, 888, 999, 555, 111, 333 ],
      'total_paid': [ 111, 222, 333, 444, 555, 666, 777, 888, 999 ],
      'total_reserve': [ 333, 444, 999, 111, 666, 777, 222, 888, 555 ],
      'indem': [ 333, 111, 888, 777, 666, 444, 222, 999, 555 ],
      'med': [ 333, 555, 222, 111, 444, 666, 999, 888, 777 ],
      'legal': [ 222, 111, 666, 999, 333, 555, 888, 444, 777 ],
      'entry': [ 111, 222, 333, 444, 555, 666, 777, 888, 999 ],
    }

    for (var column in expectedSortedClaimIds) {
      sortedClaimIds = _.pluck(ClaimsService.sortClaims(claims, column, true), 'claim_id');
      expect(sortedClaimIds).toEqual(expectedSortedClaimIds[column]);

      sortedClaimIds = _.pluck(ClaimsService.sortClaims(claims, column, false), 'claim_id');
      expect(sortedClaimIds).toEqual(expectedSortedClaimIds[column].reverse());
    };
  });

  it('should update claims', function () {
    spyOn(ClaimService, 'updateClaim');
    ClaimsService.updateClaims(claims, user);
    expect(ClaimService.updateClaim.calls.count()).toBe(9);
  });

  it('should update due dates', function () {
    var featureDates = [
      { feature_id: 'dambeaver', due: futureDate1.toDate() },
      { feature_id: 'beaverlove', due: futureDate2.toDate() }
    ];

    spyOn(ClaimService, 'updateClaim');
    ClaimsService.updateDueDates(claims, featureDates, user);
    expect(ClaimService.updateClaim.calls.count()).toBe(2);
  });
});
