'use strict';

describe('Focus Factory', function () {
  var http, mockElement, timeout, window, FocusFactory;

  beforeEach(module('Dashboard'));

  beforeEach(inject(function ($httpBackend, $timeout, $window, _FocusFactory_) {
    http = $httpBackend;
    timeout = $timeout;
    window = $window;
    FocusFactory = _FocusFactory_;
    http.when('GET', /.+/).respond();
  }));

  it('should have a defined Focus factory', function () {
    $(document.body).append($('<input id="alfa">'));
    $(document.body).append($('<input id="bravo">'));
    expect(FocusFactory).toBeDefined();
  });

  it('should focus', function () {
    var element1 = window.document.getElementById('alfa'),
      element2 = window.document.getElementById('bravo'),
      element3 = window.document.getElementById('charlie');

    expect(element1).toBeDefined();
    expect(element2).toBeDefined();
    expect(element3).toBeFalsy();

    spyOn(element1, 'focus');
    FocusFactory('alfa');
    timeout.flush();
    expect(element1.focus).toHaveBeenCalled();

    spyOn(element2, 'focus');
    expect(element2.focus).not.toHaveBeenCalled();
  });
});
