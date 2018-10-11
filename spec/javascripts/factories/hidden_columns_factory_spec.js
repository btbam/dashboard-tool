'use strict';

describe('Hidden Columns Factory', function () {
  var $httpBackend, http, scope, HiddenColumnsFactory;
  var mockGetResponse = [ { id: 123, get: true } ];
  var mockPutResponse = { id: 123, put: true };

  beforeEach(module('Dashboard'));
  beforeEach(inject(function ($httpBackend, $rootScope, _HiddenColumnsFactory_) {
    scope = $rootScope.$new();
    HiddenColumnsFactory = _HiddenColumnsFactory_;
    http = $httpBackend;
    http.when('GET', '/monitoring/alerts').respond([]);
    http.when('GET', /\/api\/hidden_columns\/\d+$/).respond(mockGetResponse);
    http.when('PUT', '/api/hidden_columns').respond(mockPutResponse);
  }));

  it('should get hidden columns', function () {
    var response = HiddenColumnsFactory.query({id: 123});
    scope.$digest();
    http.flush();
    expect(angular.equals(response, mockGetResponse)).toBe(true);
  });

  it('should put hidden columns', function () {
    var response = HiddenColumnsFactory.update([{id: 123}]);
    scope.$digest();
    http.flush();
    expect(angular.equals(response, mockPutResponse)).toBe(true);
  });
});
