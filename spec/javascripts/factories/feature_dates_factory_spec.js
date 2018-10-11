'use strict';

describe('Feature Dates Factory', function () {
  var FeatureDatesFactory;

  beforeEach(module('Dashboard'));
  beforeEach(inject(function (_FeatureDatesFactory_) {
    FeatureDatesFactory = _FeatureDatesFactory_;
  }));

  it('should be defined', function () {
    expect(FeatureDatesFactory).toBeDefined();
  });
});
