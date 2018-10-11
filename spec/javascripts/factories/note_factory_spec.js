'use strict';

describe('Note Factory', function () {
  var $httpBackend, http, scope, NoteFactory;
  var mockGetResponse = [ { id: 123, get: true } ];
  var mockPutResponse = { id: 123, put: true };

  beforeEach(module('Dashboard'));
  beforeEach(inject(function ($httpBackend, $rootScope, _NoteFactory_) {
    scope = $rootScope.$new();
    NoteFactory = _NoteFactory_;
    http = $httpBackend;
    http.when('GET', '/monitoring/alerts').respond([]);
    http.when('GET', /\/api\/notes\?id=\d+$/).respond(mockGetResponse);
    http.when('PUT', '/api/notes').respond(mockPutResponse);
  }));

  it('should get notes', function () {
    var response = NoteFactory.query({id: 123});
    scope.$digest();
    http.flush();
    expect(angular.equals(response, mockGetResponse)).toBe(true);
  });

  it('should put notes', function () {
    var response = NoteFactory.update([{id: 123}]);
    scope.$digest();
    http.flush();
    expect(angular.equals(response, mockPutResponse)).toBe(true);
  });
});
