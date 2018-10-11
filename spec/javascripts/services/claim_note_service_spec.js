'use strict';

describe('Claim Note Service', function () {
  var $httpBackend, author1, author2, diary_notes, http, note1, note2, notes, scope, ClaimNoteService;

  author1 = { id: 3734, name: 'Scarlett Johannson', manager_id: 'JK8N', email: 'SJOHANNSON@Dashboard.COM', adjuster_id: 'JNHA' };
  author2 = { id: 3735, name: 'Scott Baio', manager_id: 'JK8N', email: 'SCOTT.BAIO@Dashboard.COM', adjuster_id: 'JNHA' };
  diary_notes = [ 'd', 'e', 'f' ]; 
  note1 = {
    id: 123,
    message: 'message',
    note_title: 'note title',
    dashboard_updated_at: '2015-04-12T11:45:47.707-04:00',
    author: author1
  };
  note2 = {
    id: 456,
    message: 'message',
    note_title: 'note title',
    dashboard_updated_at: '2016-04-12T11:45:47.707-04:00',
    author: author2
  };
  notes = [ 'a', 'b', 'c' ];

  beforeEach(module('Dashboard'));
  beforeEach(inject(function ($httpBackend, $rootScope, _ClaimNoteService_) {
    scope = $rootScope.$new();
    ClaimNoteService = _ClaimNoteService_;
    http = $httpBackend;
    http.when('GET', '/monitoring/alerts').respond([]);
    http.when('GET', /\/api\/notes\?.*?/).respond(notes);
    http.when('GET', /\/api\/diary_notes\/.*?/).respond(diary_notes);
  }));

  it('should return days since last note', function () {
    var claim = {}, days = [ 1, 30, 31, 60, 61, 90, 91, 1500 ];

    expect(ClaimNoteService.daysSinceLastNote(claim)).toBe(0);

    ClaimNoteService.lastNoteType = '';
    claim.last_adjuster_note = note1;

    _.each(days, function (day) {
      claim.last_adjuster_note.dashboard_updated_at = new moment().startOf('day').subtract(day, 'days').toDate();
      expect(ClaimNoteService.daysSinceLastNote(claim)).toBe(day);
    });
  });

  it('should return last claim note', function () {
    var claim = {};
    var lastNote;

    expect(ClaimNoteService.lastNoteForClaim(claim)).toBeUndefined();

    // Only has adjuster note
    claim.last_adjuster_note = note1;
    expect(ClaimNoteService.lastNoteForClaim(claim).id).toBe(123);

    ClaimNoteService.lastNoteType = 'adjuster';
    expect(ClaimNoteService.lastNoteForClaim(claim).id).toBe(123);

    ClaimNoteService.lastNoteType = 'manager';
    expect(ClaimNoteService.lastNoteForClaim(claim)).toBeUndefined();

    // Only has manager note
    claim.last_manager_note = note1;
    delete(claim.last_adjuster_note);
    expect(ClaimNoteService.lastNoteForClaim(claim).id).toBe(123);

    ClaimNoteService.lastNoteType = 'adjuster';
    expect(ClaimNoteService.lastNoteForClaim(claim)).toBeUndefined();

    ClaimNoteService.lastNoteType = 'manager';
    expect(ClaimNoteService.lastNoteForClaim(claim).id).toBe(123);

    // Has manager and adjuster note
    claim.last_adjuster_note = note1;
    claim.last_manager_note = note2;

    ClaimNoteService.lastNoteType = '';
    expect(ClaimNoteService.lastNoteForClaim(claim).id).toBe(456);

    ClaimNoteService.lastNoteType = 'adjuster';
    expect(ClaimNoteService.lastNoteForClaim(claim).id).toBe(123);

    ClaimNoteService.lastNoteType = 'manager';
    expect(ClaimNoteService.lastNoteForClaim(claim).id).toBe(456);
  });

  it('should return last note severity for month', function () {
    var claim = {}, days, tests = { 1: 'low', 30: 'low', 31: 'med-low', 60: 'med-low',
      61: 'med', 90: 'med', 91: 'high', 1500: 'high' };

    expect(ClaimNoteService.lastNoteSeverity(claim)).toBe('low');

    ClaimNoteService.lastNoteTimeFrame = 'month';
    ClaimNoteService.lastNoteType = '';
    claim.last_adjuster_note = note1;

    for (days in tests) {
      claim.last_adjuster_note.dashboard_updated_at = new moment().startOf('day').subtract(days, 'days').toDate();
      expect(ClaimNoteService.lastNoteSeverity(claim)).toBe(tests[days]);
    }
  });

  it('should return last note severity for week', function () {
    var claim = {}, days, tests = { 1: 'low', 7: 'low', 8: 'med-low', 14: 'med-low',
      15: 'med', 30: 'med', 31: 'high', 1500: 'high' };

    expect(ClaimNoteService.lastNoteSeverity(claim)).toBe('low');

    ClaimNoteService.lastNoteTimeFrame = 'week';
    ClaimNoteService.lastNoteType = '';
    claim.last_adjuster_note = note1;

    for (days in tests) {
      claim.last_adjuster_note.dashboard_updated_at = new moment().startOf('day').subtract(days, 'days').toDate();
      expect(ClaimNoteService.lastNoteSeverity(claim)).toBe(tests[days]);
    }
  });

  it('should return note class', function () {
    var note = {};

    expect(ClaimNoteService.noteClass(note)).toBe('note');

    note.object_type = 'Notification';
    expect(ClaimNoteService.noteClass(note)).toBe('notification');

    note.object_type = 'DiaryNote';
    expect(ClaimNoteService.noteClass(note)).toBe('follow-up');

    note.diary_note_types = [ 'call' ];
    expect(ClaimNoteService.noteClass(note)).toBe('call');

    note.diary_note_types = [ 'reminder' ];
    expect(ClaimNoteService.noteClass(note)).toBe('reminder');

    note.diary_note_types = [ 'email' ];
    expect(ClaimNoteService.noteClass(note)).toBe('email');
  });

  it('should return note icon', function () {
    var note = {};

    expect(ClaimNoteService.noteIcon(note)).toBe('icon-label-note-off.svg');

    note.object_type = 'Notification';
    expect(ClaimNoteService.noteIcon(note)).toBe('icon-notification-off.svg');

    note.object_type = 'DiaryNote';
    expect(ClaimNoteService.noteIcon(note)).toBe('icon-label-follow-up-off.svg');

    note.diary_note_types = [ 'diary' ];
    expect(ClaimNoteService.noteIcon(note)).toBe('icon-reminder-off.svg');

    note.diary_note_types = [ 'email' ];
    expect(ClaimNoteService.noteIcon(note)).toBe('icon-label-email-off.svg');

    note.diary_note_types = [ 'call' ];
    expect(ClaimNoteService.noteIcon(note)).toBe('icon-label-call-off.svg');

    note.diary_note_types = [ 'follow-up' ];
    expect(ClaimNoteService.noteIcon(note)).toBe('icon-label-follow-up-off.svg');

    note.diary_note_types = [ 'reminder' ];
    expect(ClaimNoteService.noteIcon(note)).toBe('icon-reminder-off.svg');
  });

  it('should update claim notes', function () {
    var claim = { claim_id: 123, dashboard_compound_key: '123456-7' };

    ClaimNoteService.updateClaimNotes(claim);
    scope.$digest();
    http.flush();

    expect(angular.equals(claim.notes, notes)).toBe(true);
    expect(claim.loadedNotes).toBe(true);
    expect(angular.equals(claim.diary_notes, diary_notes)).toBe(true);
    expect(claim.loadedDiaryNotes).toBe(true);
  });
});
