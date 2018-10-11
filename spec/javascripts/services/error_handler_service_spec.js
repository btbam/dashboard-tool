'use strict';

describe('Error Handler Service', function () {
  var ErrorHandlerService;

  beforeEach(module('Dashboard'));
  beforeEach(inject(function (_ErrorHandlerService_) {
    ErrorHandlerService = _ErrorHandlerService_;
    // temporarily redefining alert function to suppress output
    alert = function() {};
  }));

  it('should log error', function () {
    spyOn(console, 'log');
    ErrorHandlerService.general();
    expect(console.log).toHaveBeenCalled();
  });
});
