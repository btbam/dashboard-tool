'use strict';

describe('User Factory', function () {
  var UserFactory;

  beforeEach(module('Dashboard'));
  beforeEach(inject(function (_UserFactory_) {
    UserFactory = _UserFactory_;
  }));

  it('should be defined', function () {
    expect(UserFactory).toBeDefined();
  });
});
