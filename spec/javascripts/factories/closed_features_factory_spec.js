'use strict';

describe('Closed Features Factory', function () {
  var ClosedFeaturesFactory;

  beforeEach(module('Dashboard'));
  beforeEach(inject(function (_ClosedFeaturesFactory_) {
    ClosedFeaturesFactory = _ClosedFeaturesFactory_;
  }));

  it('should be defined', function () {
    expect(ClosedFeaturesFactory).toBeDefined();
  });
});
