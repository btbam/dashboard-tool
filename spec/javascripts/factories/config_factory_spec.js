'use strict';

describe('Config Factory', function () {
  var ConfigFactory;

  beforeEach(module('Dashboard'));
  beforeEach(inject(function (_ConfigFactory_) {
    ConfigFactory = _ConfigFactory_;
  }));

  it('should be defined', function () {
    expect(ConfigFactory).toBeDefined();
  });
});
