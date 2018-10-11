'use strict';

describe('Claim Service', function () {
  var claims, futureDate1, futureDate2, pastDate1, pastDate2, pastDate3, today,
    ClaimService, ClaimsService, GlobalDataService, http, scope, user;

  futureDate1 = new moment().add(100, 'days').startOf('day');
  futureDate2 = new moment().add(69, 'days').startOf('day');
  pastDate1 = new moment().subtract(300, 'days').startOf('day');
  pastDate2 = new moment().subtract(42, 'days').startOf('day');
  pastDate3 = new moment().subtract(12, 'days').startOf('day');
  today = new moment().startOf('day');
  user = {id: 1, is_manager: false, is_adjuster: true };

  claims = [
    { claim_id: 111, feature_id: 2, litigation: 'hell yeah', loadedNotes: true,
      notes: [ { dashboard_updated_at: pastDate1.toDate() } ], flags: [ { type: 'duration' }],
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Sabina' } },
      last_adjuster_note: { dashboard_updated_at: pastDate1.toDate(), message: 'a' },
      last_manager_note: { dashboard_updated_at: pastDate2.toDate(), message: 'c' },
      'adjuster_name': 'Beavis', state: 'Alabama', claimant_name: 'Quinn',
      total_reserve: 12, total_outstanding: 45, indemnity_outstanding: 16, medical_outstanding: 33, legal_outstanding: 9,
      notifications: [ { notification_type: 'DiaryNote', triggering_user: { name: 'Justin' }} ],
      feature_date: { due: null },
      last_adjuster_summary: { diary_scheduled_date: null },
      last_manager_summary: { diary_scheduled_date: null }
    },

    { claim_id: 222, feature_id: 1, notes: [ { dashboard_updated_at: pastDate2.toDate() } ], loadedNotes: true,
      flags: [ { type: 'touch' }], 'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'David' } },
      diary_notes: [ { diary: 'diary yeah', diary_note_types: ['email'], created_at: pastDate3.toDate() } ],
      last_manager_note: { dashboard_updated_at: pastDate2.toDate(), message: 'b' },
      last_adjuster_note: { dashboard_updated_at: pastDate1.toDate(), message: 'd' }, 'adjuster_name': 'Butthead',
      state: 'Oregon', claimant_name: 'Justin', total_reserve: 66, total_outstanding: 500,
      indemnity_outstanding: 999, medical_outstanding: 22.5, legal_outstanding: 1,
      notifications: [ { notification_type: 'ModelScore', triggering_user: { name: 'Roger' }},
        { notification_type: 'DiaryNote', triggering_user: { name: 'Justin' }} ],
      feature_date: { due: null },
      last_adjuster_summary: { diary_scheduled_date: null },
      last_manager_summary: { diary_scheduled_date: null }
    },

    { claim_id: 333, feature_id: 3, feature_date: { due: futureDate1.toDate() }, notes: [], loadedNotes: true,
      flags: [ { type: 'duration' }], diary_notes: [ { diary: 'yeah', diary_note_types: ['email'], created_at: pastDate1.toDate() } ],
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Thoreau' }},
      state: 'California', last_adjuster_note: { dashboard_updated_at: pastDate2.toDate(), message: 'c' }, 'adjuster_name': 'Allison',
      claimant_name: 'Lily', total_reserve: 199, total_outstanding: 4, indemnity_outstanding: 6,
      medical_outstanding: 3, legal_outstanding: 999,
      notifications: [ { notification_type: 'ModelScore', triggering_user: { name: 'Justin' } } ],
      last_adjuster_summary: { diary_scheduled_date: null },
      last_manager_summary: { diary_scheduled_date: null }
    },

    { claim_id: 444, feature_id: 1, feature_date: { due: futureDate2.toDate() }, notes: [], loadedNotes: true,
      flags: [ { type: 'touch' }], diary_notes: [ { diary: 'roadrunner', diary_note_types: ['follow-up'], created_at: pastDate3.toDate() } ],
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Henry' }},
      'adjuster_name': 'Roger', state: 'Texas', claimant_name: 'Fred',
      total_reserve: 1, total_outstanding: 4.5, indemnity_outstanding: 666, medical_outstanding: 100,
      legal_outstanding: 9999,
      notifications: [ { notification_type: 'NewNotificationType', triggering_user: { name: 'Justin' } } ],
      last_adjuster_summary: { diary_scheduled_date: null },
      last_manager_summary: { diary_scheduled_date: null }
    },

    { claim_id: 555, feature_id: 4, feature_date: { due: futureDate2.toDate() }, notes: [], loadedNotes: true,
      flags: [ { type: 'touch' }], diary_notes: [ { diary: 'yellow', diary_note_types: ['follow-up'] } ],
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Reginald' }},
      'adjuster_name': 'David', state: 'Idaho', claimant_name: 'Jesus',
      total_reserve: 1000, total_outstanding: 45000, indemnity_outstanding: 16000, medical_outstanding: 3.3,
      legal_outstanding: 1239.12,
      notifications: [ { notification_type: 'ModelScore', triggering_user: { name: 'Beavis' }},
        { notification_type: 'DiaryNote', triggering_user: { name: 'Justin' }} ],
      last_adjuster_summary: { diary_scheduled_date: null },
      last_manager_summary: { diary_scheduled_date: null }
    },

    { claim_id: 666, feature_id: 6, feature_date: { due: pastDate1.toDate() }, loadedNotes: true,
      notes: [], diary_notes: [ { diary: 'negative', diary_note_types: ['email'] } ],
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Jennifer' } },
      'adjuster_name': 'Stephen', state: 'Colorado', claimant_name: 'Trump',
      total_reserve: 0, total_outstanding: 93, indemnity_outstanding: 373, medical_outstanding: 123.3,
      legal_outstanding: 12.39,
      notifications: [ { notification_type: 'DiaryNote', triggering_user: { name: 'HoneyBadger' }},
        { notification_type: 'DiaryNote', triggering_user: { name: 'Justin' }},
        { notification_type: 'DiaryNote', triggering_user: { name: 'Dick' }} ],
      last_adjuster_summary: { diary_scheduled_date: null },
      last_manager_summary: { diary_scheduled_date: null }
    },

    { claim_id: 777, feature_id: 9, feature_date: { due: pastDate2.toDate() }, loadedNotes: true,
      notes: [], diary_notes: [ { diary_note_types: ['call'] } ], dashboard_compound_key: 'dambeaver',
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Dick' }}, litigation: 'yeah',
      'adjuster_name': 'Roadrunner', state: 'New York', claimant_name: 'Buckethead', total_reserve: 1000,
      total_outstanding: 450, indemnity_outstanding: 160, medical_outstanding: 99993.3,
      legal_outstanding: 123922.12,
      notifications: [{ notification_type: 'DiaryNote', triggering_user: { name: 'Fred' }} ],
      last_adjuster_summary: { diary_scheduled_date: null },
      last_manager_summary: { diary_scheduled_date: null }
    },

    { claim_id: 888, feature_id: 11, notes: [], dashboard_compound_key: 'beaverlove', state: 'Nevada',
      'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Mo' } }, 'adjuster_name': 'Elvis',
      claimant_name: 'Tony', total_reserve: 100, total_outstanding: 937, indemnity_outstanding: 94.44,
      medical_outstanding: 6482, legal_outstanding: 9371, loadedNotes: true,
      notifications: [{ notification_type: 'FartAlert', triggering_user: { name: 'Jesus' }} ],
      feature_date: { due: null },
      last_adjuster_summary: { diary_scheduled_date: null },
      last_manager_summary: { diary_scheduled_date: null }
    },

    { claim_id: 999, feature_id: 3, force_closed: true, feature_date: { due: pastDate2.toDate() },
      notes: [], 'case': { receipt_date: pastDate1.toDate(), policy: { insured_name: 'Quinn' } },
      'adjuster_name': 'Anie', state: 'Missouri', claimant_name: 'Bert', loadedNotes: true,
      total_reserve: 8, total_outstanding: 7, indemnity_outstanding: 1008, medical_outstanding: 123.3,
      legal_outstanding: 123.55,
      last_adjuster_summary: { diary_scheduled_date: null },
      last_manager_summary: { diary_scheduled_date: null }
   },
  ];

  beforeEach(module('Dashboard'));

  beforeEach(inject(function ($httpBackend, $rootScope, _ClaimService_, _ClaimsService_, _GlobalDataService_) {
    scope = $rootScope.$new();
    ClaimService = _ClaimService_;
    ClaimsService = _ClaimsService_;
    GlobalDataService = _GlobalDataService_;

    http = $httpBackend;
    http.when('GET', '/monitoring/alerts').respond([]);
    http.when('GET', '/api/users/me').respond();
    http.when('GET', '/api/hidden_columns').respond();
    scope.$digest();
    http.flush();

    ClaimsService.updateClaims(claims, user);

  }));

  it('should calculate age', function () {
    var expectedAges = [ 42, 42, 42, 300, 300, 300, 300, 300, 300 ];
    expect(_.pluck(claims, 'age')).toEqual(expectedAges);
  });

  it('should return feature date', function () {
    var expectedFeatureDates = [
      undefined,
      undefined,
      futureDate1.toDate(),
      futureDate2.toDate(),
      futureDate2.toDate(),
      pastDate1.toDate(),
      pastDate2.toDate(),
      undefined,
      pastDate2.toDate()
    ];
    var featureDates = [];

    _.each(claims, function (claim) {
      featureDates.push(ClaimService.featureDate(claim, user));
    });
    expect(featureDates).toEqual(expectedFeatureDates);
  });

  it('should return fullId', function () {
    var expectedFullIds = [ '111-2', '222-1', '333-3', '444-1', '555-4', '666-6', '777-9', '888-11', '999-3' ];
    expect(_.pluck(claims, 'fullId')).toEqual(expectedFullIds);
  });

  it('should return isPastDue', function () {
    var expectedIsPastDue = [ false, false, false, false, false, true, true, false, true ];
    expect(_.pluck(claims, 'isPastDue')).toEqual(expectedIsPastDue);
  });

  it('should calculate searchString', function () {
    _.each(claims, function (claim) {
      expect(claim.searchString.length > 0).toBe(true);
    });
  });

  it('should calculate startsAt', function () {
    var clonedClaim, days, dueDate, expectedStartsAt = [], startsAt = [];

    _.each(claims, function (claim) {
      clonedClaim = _.clone(claim);
      days = Math.floor((Math.random() * 100) + 1);
      dueDate = new moment();

      // Future
      if (Math.random() > .3) {
        dueDate.add(days, 'days').startOf('day');
      }
      // Past
      else {
        dueDate.subtract(days, 'days').startOf('day');
      }
      expectedStartsAt.push(dueDate.format('YYYYMMDD'));

      clonedClaim.notifications = [];
      clonedClaim.feature_date = {};
      clonedClaim.feature_date.due = dueDate.toDate();
      ClaimService.updateClaim(clonedClaim, user);
      startsAt.push(new moment(clonedClaim.startsAt).format('YYYYMMDD'));
    });

    expect(startsAt).toEqual(expectedStartsAt);
  });

  it('should return title', function() {
    var expectedTitles = [
      'c',
      'diary yeah',
      'c',
      'roadrunner',
      'yellow',
      'negative',
      '-',
      '-',
      '-'
    ];
    expect(_.pluck(claims, 'title')).toEqual(expectedTitles);
  });

  it('should return sortvalue', function () {
    var claimSortValues, columns, expectedSortValues, idx = 0;

    columns = [ 'claim_id', 'due_date', 'age', 'litigation', 'adjuster', 'state', 'claimant', 'insured',
      'total_paid', 'total_reserve', 'indem', 'med', 'legal', 'entry' ];

    expectedSortValues = [
      ['111-2', undefined, 42, 'hell yeah', 'beavis', 'alabama', 'quinn', 'sabina', NaN, 45, 16, 33, 9, 'c'],
      ['222-1', undefined, 42, 'n/a', 'butthead', 'oregon', 'justin', 'david', NaN, 500, 999, 22.5, 1, 'diary yeah'],
      ['333-3', futureDate1.toDate(), 42, 'n/a', 'allison', 'california', 'lily', 'thoreau', NaN, 4, 6, 3, 999, 'c'],
      ['444-1', futureDate2.toDate(), 300, 'n/a', 'roger', 'texas', 'fred', 'henry', NaN, 4.5, 666, 100, 9999, 'roadrunner'],
      ['555-4', futureDate2.toDate(), 300, 'n/a', 'david', 'idaho', 'jesus', 'reginald', NaN, 45000, 16000, 3.3, 1239.12, 'yellow'],
      ['666-6', pastDate1.toDate(), 300, 'n/a', 'stephen', 'colorado', 'trump', 'jennifer', NaN, 93, 373, 123.3, 12.39, 'negative'],
      ['777-9', pastDate2.toDate(), 300, 'yeah', 'roadrunner', 'new york', 'buckethead', 'dick', NaN, 450, 160, 99993.3, 123922.12, '-'],
      ['888-11', undefined, 300, 'n/a', 'elvis', 'nevada', 'tony', 'mo', NaN, 937, 94.44, 6482, 9371, '-'],
      ['999-3', pastDate2.toDate(), 300, 'n/a', 'anie', 'missouri', 'bert', 'quinn', NaN, 7, 1008, 123.3, 123.55, '-'],
    ];

    _.each(claims, function (claim) {
      claimSortValues = [];
      _.each(columns, function (column) {
        claimSortValues.push(ClaimService.sortValue(claim, column));
      });
      expect(claimSortValues).toEqual(expectedSortValues[idx++]);
    });
  });

  it('should return type', function() {
    var expectedTypes = [ 'new', 'email', 'email', 'follow-up', 'follow-up', 'email', 'call', 'new', 'new' ];
    expect(_.pluck(claims, 'type')).toEqual(expectedTypes);
  });
});
