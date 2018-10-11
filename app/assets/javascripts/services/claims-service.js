'use strict';

angular.module('Dashboard').service('ClaimsService', [
  '$filter',
  'ClaimFlagService',
  'ClaimNoteService',
  'ClaimService',
  'NoteSeverityService',
  function ($filter, ClaimFlagService, ClaimNoteService, ClaimService, NoteSeverityService) {
    var self = this, today, tomorrow;

    self.claimEventCounts = function (claims) {
      var dailyEventCounts = {};
      _.each(claims, function (claim) {
        if (! claim.force_closed && claim.startsAt) {
          var key = moment(claim.startsAt).startOf('day').format('YYYYMMDD');
          if (! dailyEventCounts[key]) {
            dailyEventCounts[key] = 0;
          }
          dailyEventCounts[key]++;
        }
      });
      return dailyEventCounts;
    };

    self.claimFilterCounts = function (claims) {
      return {
        'call': $filter('claimFilterReminder')(claims, 'call').length,
        'email': $filter('claimFilterReminder')(claims, 'email').length,
        'follow-up': $filter('claimFilterReminder')(claims, 'follow-up').length,
        'new': $filter('claimFilterNew')(claims).length,
        'notification': $filter('claimFilterNotification')(claims).length,
        'open': $filter('claimFilterOpen')(claims).length,
        'duration': $filter('claimFilterFlag')(claims, 'duration').length,
        'touch': $filter('claimFilterFlag')(claims, 'touch').length,
        'lastnote-low': $filter('claimFilterNote')(claims, 'low').length,
        'lastnote-med-low': $filter('claimFilterNote')(claims, 'med-low').length,
        'lastnote-med': $filter('claimFilterNote')(claims, 'med').length,
        'lastnote-high': $filter('claimFilterNote')(claims, 'high').length,
        'past-due': $filter('claimFilterPastDue')(claims).length,
        'no-due-date': $filter('claimFilterNoDueDate')(claims).length,
        'closed': $filter('claimFilterClosed')(claims).length,
      };
    };

    self.daysSinceLastNoteBucketCounts = function (claims) {
      var buckets = {}, counts = [], severities = [ 'low', 'med-low', 'med', 'high' ];

      _.each(severities, function (severity) {
        counts = [];
        _.each(NoteSeverityService.buckets[ClaimNoteService.lastNoteTimeFrame][severity], function (chunk) {
          counts.push(self.daysSinceLastNoteCount(claims, chunk.min, chunk.max));
        });
        buckets[severity] = counts;
      });

      return buckets;
    };

    self.daysSinceLastNoteCount = function (claims, min, max) {
      var count = 0;
      _.each(claims, function (claim) {
        if (claim.daysSinceLastNote && claim.daysSinceLastNote >= min && claim.daysSinceLastNote <= max) {
          count++;
        }
      });
      return count;
    };

    self.dueTodayCount = function (claims) {
      return _.filter(claims, function (claim) {
        return claim.startsAt && moment(claim.startsAt).startOf('day').isSame(today, 'day') && ! claim.force_closed;
      }).length;
    };

    self.filterClaims = function (claims, filter, calendarDay, searchString) {
      if (! claims) {
        return [];
      }

      switch (filter) {
        case 'new':
          return $filter('claimFilterNew')(claims);
        case 'diary':
        case 'call':
        case 'email':
        case 'follow-up':
          return $filter('claimFilterReminder')(claims, filter);
        case 'notification':
          return $filter('claimFilterNotification')(claims);
        case 'touch':
        case 'duration':
        case 'lastnote':
          return $filter('claimFilterFlag')(claims, filter);
        case 'lastnote-low':
          return $filter('claimFilterNote')(claims, 'low');
        case 'lastnote-med-low':
          return $filter('claimFilterNote')(claims, 'med-low');
        case 'lastnote-med':
          return $filter('claimFilterNote')(claims, 'med');
        case 'lastnote-high':
          return $filter('claimFilterNote')(claims, 'high');
        case 'day':
          return $filter('claimFilterDay')(claims, calendarDay);
        case 'past-due':
          return $filter('claimFilterPastDue')(claims);
        case 'no-due-date':
          return $filter('claimFilterNoDueDate')(claims);
        case 'search':
          return $filter('filter')(claims, searchString);
        case 'closed':
          return $filter('claimFilterClosed')(claims);
        default:
          return $filter('claimFilterOpen')(claims);
      }
    };

    self.maxDaysSinceLastNoteBucketCount = function (buckets) {
      var counts = [];
      _.each(buckets, function (bucket) {
        _.each(bucket, function (count) {
          counts.push(count);
        });
      });
      return _.max(counts);
    };

    self.setDaysSinceLastNote = function (claims) {
      _.each(claims, function (claim) {
        if (claim) {
          claim.daysSinceLastNote = ClaimNoteService.daysSinceLastNote(claim);
        }
      });
    };

    self.setLastNoteFlags = function (claims) {
      var severity;
      _.each(claims, function (claim) {
        if (claim) {
          severity = ClaimNoteService.lastNoteSeverity(claim);
          claim.flags = _.reject(claim.flags, function (flag) {
            return flag.type === 'lastnote';
          });
          if (severity) {
            claim.flags.push({
              type: 'lastnote',
              severity: severity
            });
          }
        }
      });
    };

    self.sortClaims = function (claims, sortColumn, sortAscending) {
      claims = _.sortBy(claims, function (claim) {
        return ClaimService.sortValue(claim, sortColumn);
      });
      if (! sortAscending) {
        claims = claims.reverse();
      }
      return claims;
    };

    self.updateClaims = function (claims, user) {
      _.each(claims, function (claim) {
        ClaimService.updateClaim(claim, user);
      });
    };

    self.updateDueDates = function (claims, featureDates, user) {
      var claim;
      _.each(featureDates, function (featureDate) {
        claim = _.find(claims, function (claim) {
          return claim.dashboard_compound_key === featureDate.feature_id;
        });
        if (claim) {
          claim.feature_date.due = featureDate.due;
          ClaimService.updateClaim(claim, user);
        }
      });
    };

    today = new moment().startOf('day').toDate();
    tomorrow = moment(today).add(1, 'day').startOf('day');
  }
]);
