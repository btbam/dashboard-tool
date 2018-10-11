'use strict';

describe('Diary Note Factory', function () {
  var $httpBackend, http, scope, DiaryNote;
  var mockGetResponse = [ { id: 123, get: true } ];
  var mockPutResponse = { id: 123, put: true };

  beforeEach(module('Dashboard'));
  beforeEach(inject(function ($httpBackend, $rootScope, _DiaryNoteFactory_) {
    scope = $rootScope.$new();
    DiaryNote = _DiaryNoteFactory_;
    http = $httpBackend;
    http.when('GET', '/monitoring/alerts').respond([]);
    http.when('GET', /\/api\/diary_notes\/\d+$/).respond(mockGetResponse);
    http.when('PUT', '/api/diary_notes').respond(mockPutResponse);
  }));

  it('should get diary notes', function () {
    var response = DiaryNote.query({id: 123});
    scope.$digest();
    http.flush();
    expect(angular.equals(response, mockGetResponse)).toBe(true);
  });

  it('should put diary notes', function () {
    var response = DiaryNote.update({id: 123});
    scope.$digest();
    http.flush();
    expect(angular.equals(response, mockPutResponse)).toBe(true);
  });
});
