'use strict';

angular.module('Dashboard').service('ClaimService', [
  '$filter',
  'ClaimFlagService',
  'ClaimNoteService',
  function ($filter, ClaimFlagService, ClaimNoteService) {
    var self = this, today;

    self.age = function (claim) {
      var lastDate = new moment(claim.case.receipt_date).startOf('day');
      var lastNote = ClaimNoteService.lastNoteForClaim(claim);
      if (lastNote) {
        lastDate = new moment(lastNote.dashboard_updated_at).startOf('day');
      }
      return new moment().startOf('day').diff(lastDate, 'days');
    };

    self.featureDate = function (claim, user) {
      var featureDate;
      var claim_feature_date = claim.feature_date;
      var last_adjuster_feature_date = claim.last_adjuster_feature_date;
      var last_adjuster_summary = claim.last_adjuster_summary;
      var last_manager_feature_date = claim.last_manager_feature_date;
      var last_manager_summary = claim.last_manager_summary;

      if (claim_feature_date && claim_feature_date.due) {
        featureDate = claim_feature_date.due;
      }
      else if (user.is_manager || ! user.is_adjuster) {
        if (last_manager_feature_date && last_manager_feature_date.due) {
          featureDate = last_manager_feature_date.due;
        }
        else if (last_manager_summary && last_manager_summary.diary_scheduled_date) {
          featureDate = last_manager_summary.diary_scheduled_date;
        }
      }
      else if (user.is_adjuster || ! user.is_manager) {
        if (last_adjuster_feature_date && last_adjuster_feature_date.due) {
          featureDate = last_adjuster_feature_date.due;
        }
        else if (last_adjuster_summary && last_adjuster_summary.diary_scheduled_date) {
          featureDate = last_adjuster_summary.diary_scheduled_date;
        }
      }

      if (featureDate) {
        return new moment(featureDate).startOf('day').toDate();
      }
    };

    self.fullId = function (claim) {
      return claim.claim_id + '-' + claim.feature_id;
    };

    self.isPastDue = function (claim) {
      if (claim.feature_date && claim.feature_date.due) {
        return moment(claim.feature_date.due).isBefore(new Date(), 'day');
      }
      return false;
    };

    self.searchString = function (claim) {
      var searchBlocks = [];
      searchBlocks.push(
        claim.type,
        claim.title,
        claim.startsAt,
        claim.age,
        claim.fullId
      );
      return searchBlocks.join(' ');
    };

    self.sortValue = function (claim, sortColumn) {
      switch (sortColumn) {
        case 'claim_id':
          return claim.fullId;
        case 'due_date':
          return claim.startsAt;
        case 'flags':
          return ClaimFlagService.claimFlagCount(claim);
        case 'age':
          return claim.age;
        case 'litigation':
          return claim.litigation.toLowerCase();
        case 'adjuster':
          return claim.adjuster_name.toLowerCase();
        case 'state':
          return claim.state.toLowerCase();
        case 'claimant':
          return claim.claimant_name.toLowerCase();
        case 'insured':
          return claim.case.policy.insured_name.toLowerCase();
        case 'total_paid':
          return parseFloat(claim.total_paid);
        case 'total_reserve':
          return parseFloat(claim.total_outstanding);
        case 'indem':
          return parseFloat(claim.indemnity_outstanding);
        case 'med':
          return parseFloat(claim.medical_outstanding);
        case 'legal':
          return parseFloat(claim.legal_outstanding);
        case 'entry':
          return claim.title.toLowerCase();
      }
      return '';
    };

    self.startsAt = function (claim) {
      if (claim.feature_date && claim.feature_date.due) {
        return moment(claim.feature_date.due).startOf('day').toDate();
      }
    };

    self.title = function (claim) {
      var lastDate, title = '';
      if (claim.last_manager_note && claim.last_manager_note.message) {
        title = claim.last_manager_note.message;
        lastDate = new moment(claim.last_manager_note.dashboard_updated_at);
      }
      if (claim.last_adjuster_note && claim.last_adjuster_note.message) {
        if (! lastDate || lastDate.isBefore(claim.last_adjuster_note.dashboard_updated_at)) {
          title = claim.last_adjuster_note.message;
          lastDate = new moment(claim.last_adjuster_note.dashboard_updated_at);
        }
      }
      if (claim.diary_notes && claim.diary_notes.length && claim.diary_notes[0] !== null &&
        claim.diary_notes[0].diary) {
        if (! lastDate || lastDate.isBefore(claim.diary_notes[0].created_at)) {
          title = claim.diary_notes[0].diary;
        }
      }
      return title.length ? title : '-';
    };

    self.type = function (claim) {
      var claim_type = 'new'; // Currently not used, need new definition of New

      if (claim.diary_notes && claim.diary_notes.length && claim.diary_notes[0] !== null) {
        claim_type = claim.diary_notes[0].diary_note_types && claim.diary_notes[0].diary_note_types.length ?
          claim.diary_notes[0].diary_note_types[0] : 'follow-up';
      }

      return claim_type;
    };

    self.updateClaim = function (claim, user) {
      if (! claim.notes) {
        var lastNote = ClaimNoteService.lastNoteForClaim(claim);
        if (lastNote) {
          claim.notes = [ lastNote ];
        }
      }

      if (! claim.litigation || ! claim.litigation.length) {
        claim.litigation = 'N/A';
      }

      claim.age = self.age(claim);
      claim.feature_date.due = self.featureDate(claim, user);
      claim.isPastDue = self.isPastDue(claim);
      claim.fullId = self.fullId(claim);
      claim.startsAt = self.startsAt(claim, user);
      claim.title = self.title(claim);
      claim.type = self.type(claim);

      // Must be last
      claim.searchString = self.searchString(claim);
    };

    today = new moment().startOf('day').toDate();
  }
]);
