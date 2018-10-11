'use strict';

describe('Claim Factory', function () {
  var ClaimFactory;

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_ClaimFactory_) {
    ClaimFactory = _ClaimFactory_;
  }));

  it('should be defined', function () {
    expect(ClaimFactory).toBeDefined();
  });
});
