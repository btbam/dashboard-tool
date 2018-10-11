'use strict';

describe('Adjusters Factory', function () {
  var AdjustersFactory;

  beforeEach(module('Dashboard'));
  beforeEach(inject(function (_AdjustersFactory_) {
    AdjustersFactory = _AdjustersFactory_;
  }));

  it('should be defined', function () {
    expect(AdjustersFactory).toBeDefined();
  });
});
