'use strict';

describe('App Header Service', function () {
  var AppHeaderService;

  beforeEach(module('Dashboard'));

  beforeEach(inject(function (_AppHeaderService_) {
    AppHeaderService = _AppHeaderService_;
  }));

  it('should toggle hide/show menu visibility', function () {
    expect(AppHeaderService.hideShowMenuVisible).toBeFalsy();
    AppHeaderService.toggleHideShowMenu();
    expect(AppHeaderService.hideShowMenuVisible).toBeTruthy();
    AppHeaderService.toggleHideShowMenu();
    expect(AppHeaderService.hideShowMenuVisible).toBeFalsy();
  });
});
