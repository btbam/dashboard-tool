'use strict';

describe('Claim Flag Service', function () {
  var ClaimFlagService;

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_ClaimFlagService_) {
    ClaimFlagService = _ClaimFlagService_;
  }));

  it('should determine flag displayability', function () {
    var flag = { type: 'touch' };
    expect(ClaimFlagService.canShowFlag(flag)).toBeTruthy();

    flag.type = 'duration';
    expect(ClaimFlagService.canShowFlag(flag)).toBeTruthy();

    flag = { type: 'lastnote', severity: 'low' };
    expect(ClaimFlagService.canShowFlag(flag)).toBeFalsy();

    flag = { type: 'lastnote', severity: 'med-low' };
    expect(ClaimFlagService.canShowFlag(flag)).toBeFalsy();

    flag = { type: 'lastnote', severity: 'med' };
    expect(ClaimFlagService.canShowFlag(flag)).toBeTruthy();

    flag = { type: 'lastnote', severity: 'high' };
    expect(ClaimFlagService.canShowFlag(flag)).toBeTruthy();
  });

  it('should calculate claim flag count', function () {
    var claim = {};
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(0);

    claim.flags = [];
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(0);

    claim.flags = [ { type: 'touch' } ];
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(1);

    claim.flags = [ { type: 'touch' }, { type: 'duration' } ];
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(2);

    claim.flags = [ { type: 'touch' }, { type: 'duration' }, { type: 'lastnote', severity: 'low' } ];
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(2);

    claim.flags = [ { type: 'touch' }, { type: 'duration' }, { type: 'lastnote', severity: 'med-low' } ];
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(2);

    claim.flags = [ { type: 'touch' }, { type: 'duration' }, { type: 'lastnote', severity: 'med' } ];
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(3);

    claim.flags = [ { type: 'touch' }, { type: 'duration' }, { type: 'lastnote', severity: 'high' } ];
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(3);

    claim.flags = [ { type: 'touch' }, { type: 'duration' }, { type: 'lastnote', severity: 'med' }, { type: 'futureflag1' } ];
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(4);

    claim.flags = [ { type: 'touch' }, { type: 'duration' }, { type: 'lastnote', severity: 'high' },
      { type: 'futureflag1' }, { type: 'futureflag2' } ];
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(5);

    claim.flags = [ { type: 'touch' }, { type: 'duration' }, { type: 'lastnote', severity: 'high' },
      { type: 'futureflag1' }, { type: 'futureflag2' }, { type: 'futureflag3' } ];
    expect(ClaimFlagService.claimFlagCount(claim)).toEqual(5);
  });

  it('should calculate return claim flag disputed', function () {
    var claim = {};
    claim.flags = [ { type: 'touch' }, { type: 'duration' }, { type: 'lastnote', severity: 'high' } ];

    expect(ClaimFlagService.claimFlagDisputed(claim, 'touch')).toBeFalsy();
    expect(ClaimFlagService.claimFlagDisputed(claim, 'duration')).toBeFalsy();
    expect(ClaimFlagService.claimFlagDisputed(claim, 'lastnote')).toBeFalsy();

    ClaimFlagService.disputeFlag(claim, 'touch');
    expect(ClaimFlagService.claimFlagDisputed(claim, 'touch')).toBeTruthy();

    ClaimFlagService.disputeFlag(claim, 'duration');
    expect(ClaimFlagService.claimFlagDisputed(claim, 'touch')).toBeTruthy();
  });

  it('should return claim flag existence', function () {
    var claim = {};
    expect(ClaimFlagService.claimHasFlag(claim, 'touch')).toBeFalsy();
    expect(ClaimFlagService.claimHasFlag(claim, 'duration')).toBeFalsy();
    expect(ClaimFlagService.claimHasFlag(claim, 'lastnote', 'low')).toBeFalsy();
    expect(ClaimFlagService.claimHasFlag(claim, 'futureflag1')).toBeFalsy();

    claim.flags = [ { type: 'touch' }, { type: 'duration' }, { type: 'lastnote', severity: 'high' } ];
    expect(ClaimFlagService.claimHasFlag(claim, 'touch')).toBeTruthy();
    expect(ClaimFlagService.claimHasFlag(claim, 'duration')).toBeTruthy();
    expect(ClaimFlagService.claimHasFlag(claim, 'lastnote', 'low')).toBeFalsy();
    expect(ClaimFlagService.claimHasFlag(claim, 'lastnote', 'high')).toBeTruthy();
    expect(ClaimFlagService.claimHasFlag(claim, 'futureflag1')).toBeFalsy();
  });

  it('should dispute flag', function () {
    var claim = {};
    claim.flags = [ { type: 'touch' }, { type: 'duration' }, { type: 'lastnote', severity: 'high' } ];

    expect(ClaimFlagService.claimFlagDisputed(claim, 'touch')).toBeFalsy();
    expect(ClaimFlagService.claimFlagDisputed(claim, 'duration')).toBeFalsy();
    expect(ClaimFlagService.claimFlagDisputed(claim, 'lastnote')).toBeFalsy();
    expect(ClaimFlagService.claimFlagDisputed(claim, 'futureflag1')).toBeFalsy();

    ClaimFlagService.disputeFlag(claim, 'touch');
    ClaimFlagService.disputeFlag(claim, 'duration');
    ClaimFlagService.disputeFlag(claim, 'lastnote');

    expect(ClaimFlagService.claimFlagDisputed(claim, 'touch')).toBeTruthy();
    expect(ClaimFlagService.claimFlagDisputed(claim, 'duration')).toBeTruthy();
    expect(ClaimFlagService.claimFlagDisputed(claim, 'lastnote')).toBeTruthy();
    expect(ClaimFlagService.claimFlagDisputed(claim, 'futureflag1')).toBeFalsy();
  });
});
