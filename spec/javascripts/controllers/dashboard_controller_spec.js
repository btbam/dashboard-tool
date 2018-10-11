'use strict';

describe('Dashboard Controller', function() {
  var controller, dashboard, http, scope, Claim, GlobalDataService;

  beforeEach(module('Dashboard'));

  beforeEach(inject(function($controller, $httpBackend, $rootScope, _ClaimFactory_, _GlobalDataService_){
    controller = $controller;
    scope = $rootScope.$new();
    http = $httpBackend;
    Claim = _ClaimFactory_;
    GlobalDataService = _GlobalDataService_;

    dashboard = $controller('DashboardCtrl', { $scope: scope });
    http.when('GET', /.+/).respond();
  }));

  it('dashboard controller to be defined', function () {
    expect(dashboard).toBeDefined();
    expect(dashboard.globalDataService).toBeDefined();
    expect(GlobalDataService.loadingApp).toBe(true);
  });

  it('should pull claims and update calendar', function () {
    spyOn(GlobalDataService, 'buildCalendar');
    http.flush();
    expect(GlobalDataService.buildCalendar).toHaveBeenCalled();
    expect(GlobalDataService.loadingApp).toBe(false);
  });
});
