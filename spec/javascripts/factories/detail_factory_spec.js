'use strict';

describe('Detail Factory', function () {
  var $httpBackend, expectedResponse, http, scope, DetailFactory;

  expectedResponse = [ 'mock', 'response', 'figs', 'muffins' ];

  beforeEach(module('Dashboard'));
  beforeEach(inject(function ($httpBackend, $rootScope, _DetailFactory_) {
    scope = $rootScope.$new();
    DetailFactory = _DetailFactory_;
    http = $httpBackend;
    http.when('GET', '/monitoring/alerts').respond([]);
    http.when('GET', '/api/claims/123/detail').respond(expectedResponse);
  }));

  it('should have a defined Detail service', function () {
    expect(DetailFactory).toBeDefined();
  });

  it('should return a detail response', function () {
    var response = DetailFactory.query({id: '123'});
    scope.$digest();
    http.flush();
    expect(angular.equals(response, expectedResponse)).toBe(true);
  });
});
