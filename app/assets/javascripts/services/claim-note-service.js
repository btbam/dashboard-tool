'use strict';

angular.module('Dashboard').service('ClaimNoteService', [
  'DiaryNoteFactory',
  'ErrorHandlerService',
  'NoteFactory',
  'NoteSeverityService',
  function (DiaryNoteFactory, ErrorHandlerService, NoteFactory, NoteSeverityService) {
    var self = this, today;

    self.lastNoteType = '';
    self.lastNoteTimeFrame = 'month';
    self.noteIcons = {
      'diary': 'icon-reminder-off.svg',
      'email': 'icon-label-email-off.svg',
      'call': 'icon-label-call-off.svg',
      'follow-up': 'icon-label-follow-up-off.svg',
      'note': 'icon-label-note-off.svg',
      'reminder': 'icon-reminder-off.svg',
      'notification': 'icon-notification-off.svg'
    };

    self.daysSinceLastNote = function (claim) {
      var creationDate, daysSinceLastNote, lastNote = self.lastNoteForClaim(claim), lastNoteDate;
      if (lastNote) {
        lastNoteDate = moment(lastNote.dashboard_updated_at).startOf('day');
        daysSinceLastNote = moment().startOf('day').diff(lastNoteDate, 'days');
      }
      else {
        creationDate = moment(claim.feature_created).startOf('day');
        daysSinceLastNote = moment().startOf('day').diff(creationDate, 'days');
      }
      return daysSinceLastNote;
    };

    self.lastNoteForClaim = function (claim) {
      var lastNote, lastDateAdjuster, lastDateManager;
      if (self.lastNoteType !== 'manager' && claim.last_adjuster_note) {
        lastDateAdjuster = new moment(claim.last_adjuster_note.dashboard_updated_at).startOf('day');
        lastNote = claim.last_adjuster_note;
      }
      if (self.lastNoteType !== 'adjuster' && claim.last_manager_note) {
        lastDateManager = new moment(claim.last_manager_note.dashboard_updated_at).startOf('day');
        if (! lastDateAdjuster || lastDateManager.isAfter(lastDateAdjuster)) {
          lastNote = claim.last_manager_note;
        }
      }
      return lastNote;
    };

    self.lastNoteSeverity = function (claim) {
      return NoteSeverityService.severity(self.lastNoteTimeFrame, self.daysSinceLastNote(claim));
    };

    self.noteAuthor = function (detail) {
      if (detail.author && detail.author.name && detail.author.name.length) {
        return detail.author.name;
      }
      return detail.object_type === 'Notification' ? 'Dashboard Generated' : 'No Author';
    };

    self.noteClass = function (detail) {
      switch (detail.object_type) {
        case 'DiaryNote':
          return detail.diary_note_types && detail.diary_note_types.length ?
            detail.diary_note_types[0] : 'follow-up';
        case 'Notification':
          return 'notification';
        default:
          return 'note';
      }
    };

    self.noteIcon = function (note) {
      var noteClass = self.noteClass(note);
      return self.noteIcons[noteClass] ? self.noteIcons[noteClass] : self.noteIcons.note;
    };

    self.updateClaimNotes = function (claim) {
      if (! claim.loadedNotes) {
        NoteFactory.query({claim_id: claim.claim_id}).$promise.then(function (notes) {
          claim.notes = notes;
          claim.loadedNotes = true;
        }, ErrorHandlerService.general);
      }

      if (! claim.loadedDiaryNotes) {
        DiaryNoteFactory.query({id: claim.dashboard_compound_key}).$promise.then(function (diaryNotes) {
          claim.diary_notes = diaryNotes;
          claim.loadedDiaryNotes = true;
        }, ErrorHandlerService.general);
      }
    };

    today = new moment().startOf('day').toDate();
  }
]);
