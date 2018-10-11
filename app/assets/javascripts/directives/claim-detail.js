'use strict';
angular.module('Dashboard').directive('claimDetail', [
  '$timeout',
  'ClaimFlagService',
  'ClaimNoteService',
  'ClaimService',
  'ClaimsService',
  'ClosedFeaturesFactory',
  'DetailFactory',
  'DiaryNoteFactory',
  'ErrorHandlerService',
  'FeatureDatesFactory',
  'FocusFactory',
  'GlobalDataService',
  function ($timeout, ClaimFlagService, ClaimNoteService, ClaimService, ClaimsService,
    ClosedFeaturesFactory, DetailFactory, DiaryNoteFactory, ErrorHandlerService, FeatureDatesFactory,
    FocusFactory, GlobalDataService) {
    return {
      restrict: 'E',
      templateUrl: '/assets/templates/claim-detail.html',
      scope: {
      },
      link: function (scope) {
        scope.activeNoteId = '';
        scope.claim = GlobalDataService.activeClaim;
        scope.claimFlagService = ClaimFlagService;
        scope.claimNoteService = ClaimNoteService;
        scope.datePickerOpen = false;
        scope.detailPane = 'all';
        scope.due = {};
        scope.editingNote = false;
        scope.featureDatesFactory = FeatureDatesFactory;
        scope.flagDetailVisible = false;
        scope.globalDataService = GlobalDataService;
        scope.loadedDetails = scope.claim.details ? true : false;
        scope.newDueDate = scope.claim.feature_date.due || null;
        scope.today = new Date();
        scope.updateAll = false;

        function filterDetails (details) {
          details = _(details).filter(function(detail) {
            return detail.value !== null;
          });
          return details;
        }

        scope.addNote = function (labelType) {
          if (scope.detailPane === 'notes') {
            scope.detailPane = 'reminders';
          }
          scope.editingNote = true;
          scope.claim.details = scope.claim.details || [];
          scope.claim.details.unshift({
            feature_id: scope.claim.dashboard_compound_key,
            created_at: new Date(),
            diary_edit: '',
            diary_note_types: [labelType],
            object_type: 'DiaryNote',
          });
          $timeout(function () {
            scope.claim.details[0].editing = true;
          });
        };

        scope.cancelEdit = function (note) {
          var index;
          note.editing = false;
          scope.editingNote = false;

          if(!note.id) {
            index = scope.claim.details.indexOf(note);
            scope.claim.details.splice(index, 1);
          }
        };

        scope.canShowDetailItem = function (detail) {
          if (scope.detailPane === 'reminders' && detail.object_type !== 'DiaryNote') {
            return false;
          }
          if (scope.detailPane === 'notes' && detail.object_type === 'DiaryNote') {
            return false;
          }
          return true;
        };

        scope.closeClaim = function ($event) {
          $event.stopPropagation();
          if (! confirm('Are you sure you want to close this claim?')) {
            return false;
          }

          ClosedFeaturesFactory.save({ dashboard_compound_key: scope.claim.dashboard_compound_key, close_it: true })
            .$promise.then(function () {
              scope.claim.force_closed = true;
              GlobalDataService.rebuildCalendar();
            }, ErrorHandlerService.general);
        };

        scope.dateChanged = function () {
          scope.datePickerOpen = false;
          var params = { due: scope.newDueDate, all: scope.updateAll };
          FeatureDatesFactory.update({ feature_id: scope.claim.dashboard_compound_key }, params)
            .$promise.then(function (result) {
              ClaimsService.updateDueDates(GlobalDataService.claims, result, GlobalDataService.user);
              GlobalDataService.rebuildCalendar();
            }, ErrorHandlerService.general);
        };

        scope.datePickerClick = function ($event) {
          $event.stopPropagation();
        };

        scope.deleteNote = function (note) {
          if (! confirm('Are you sure?')) {
            return false;
          }
          var resource = new DiaryNoteFactory(note);
          var promise = resource.$delete({id: note.id});
          promise.then(function (response) {
            scope.claim.diary_notes = response.last_diary_note ? [ response.last_diary_note ] : [];
            scope.claim.last_manager_note = response.last_manager_note;
            scope.claim.last_adjuster_note = response.last_adjuster_note;

            scope.claim.details = _.reject(scope.claim.details, function(detail) {
              return ! detail || detail.id === note.id;
            });
            ClaimService.updateClaim(scope.claim, GlobalDataService.user);
            GlobalDataService.rebuildCalendar();
          }, ErrorHandlerService.general);
        };

        scope.editToggle = function (note) {
          $timeout(function () {
            var resource,
                promise;

            if (note.editing) {
              if (angular.isString(note.diary_edit) && note.diary_edit.trim().length) {
                note.diary = note.diary_edit.trim();
                note.loading = true;
                var inserting = note.id ? false : true;

                resource = new DiaryNoteFactory(note);
                promise = inserting ? resource.$save() : resource.$update({id: note.id});
                promise.then(function(data){
                  note.loading = false;
                  _.extend(note, data);

                  if (inserting) {
                    scope.claim.diary_notes.unshift(note);
                  }
                  else if (scope.claim.diary_notes[0].id === note.id) {
                    scope.claim.diary_notes[0] = note;
                  }
                  ClaimService.updateClaim(scope.claim, GlobalDataService.user);
                  GlobalDataService.rebuildCalendar();
                }, ErrorHandlerService.general);
              }
              else if (! note.id) {
                scope.claim.details.shift();
              }
            }
            else {
              note.diary_edit = note.diary;
            }
            note.editing = ! note.editing;
            scope.editingNote = ! scope.editingNote;
          });
        };

        scope.processNoteKeyPress = function (event, note) {
          if (event.keyCode === 27) {
            scope.cancelEdit(note);
          }
        };

        scope.reopenClaim = function ($event) {
          $event.stopPropagation();
          if (! confirm('Are you sure you want to reopen this claim?')) {
            return false;
          }

          ClosedFeaturesFactory.save({ dashboard_compound_key: scope.claim.dashboard_compound_key, close_it: false })
            .$promise.then(function () {
              scope.claim.force_closed = false;
              GlobalDataService.rebuildCalendar();
            }, ErrorHandlerService.general);
        };

        scope.setActiveNoteId = function (noteId) {
          scope.activeNoteId = noteId;
        };

        scope.setNoteType = function (note, noteType) {
          note.diary_note_types = [noteType];
          FocusFactory('note-text');
        };

        scope.showMessage = function (detail) {
          if (detail.object_type === 'DiaryNote') {
            return detail.diary;
          }
          return detail.message;
        };

        scope.toggleDatePickerOpen = function ($event) {
          if ($event) {
            $event.preventDefault();
            $event.stopPropagation();
          }

          scope.updateAll = false;
          scope.datePickerOpen = ! scope.datePickerOpen;
        };

        if (! scope.claim.details) {
          GlobalDataService.loadingClaims = true;
          DetailFactory.query({id: scope.claim.dashboard_compound_key}).$promise.then(function (details) {
            details = filterDetails(details);
            scope.claim.details = details;
            scope.loadedDetails = true;
            GlobalDataService.loadingClaims = false;
          }, ErrorHandlerService.general);
        }
      }
    };
  }
]);
