'use strict';

describe('Note Severity Service', function () {
  var NoteSeverityService;

  beforeEach(module('Dashboard'));
  beforeEach(inject(function (_NoteSeverityService_) {
    NoteSeverityService = _NoteSeverityService_;
  }));

  it('should return last note severity breakpoint', function () {
    expect(NoteSeverityService.breakpoint('week', 'low')).toBe(0);
    expect(NoteSeverityService.breakpoint('week', 'med-low')).toBe(8);
    expect(NoteSeverityService.breakpoint('week', 'med')).toBe(15);
    expect(NoteSeverityService.breakpoint('week', 'high')).toBe(31);

    expect(NoteSeverityService.breakpoint('month', 'low')).toBe(0);
    expect(NoteSeverityService.breakpoint('month', 'med-low')).toBe(31);
    expect(NoteSeverityService.breakpoint('month', 'med')).toBe(61);
    expect(NoteSeverityService.breakpoint('month', 'high')).toBe(91);

    expect(NoteSeverityService.breakpoint('week', 'goat')).toBe(0);
    expect(NoteSeverityService.breakpoint('month', 'goat')).toBe(0);
    expect(NoteSeverityService.breakpoint('goat', 'butt')).toBe(0);
    expect(NoteSeverityService.breakpoint()).toBe(0);
  });

  it('should fix strings', function () {
    expect(NoteSeverityService.fixString('KILLMENOW')).toBe('killmenow');
    expect(NoteSeverityService.fixString('lowercase')).toBe('lowercase');
    expect(NoteSeverityService.fixString('HireMePermanentlyNow')).toBe('hiremepermanentlynow');
    expect(NoteSeverityService.fixString('')).toBe('');
  });

  it('should return last note severity label', function () {
    expect(NoteSeverityService.label('week', 'low')).toBe('0-7');
    expect(NoteSeverityService.label('week', 'med-low')).toBe('8-14');
    expect(NoteSeverityService.label('week', 'med')).toBe('15-30');
    expect(NoteSeverityService.label('week', 'high')).toBe('31+');

    expect(NoteSeverityService.label('month', 'low')).toBe('0-30');
    expect(NoteSeverityService.label('month', 'med-low')).toBe('31-60');
    expect(NoteSeverityService.label('month', 'med')).toBe('61-90');
    expect(NoteSeverityService.label('month', 'high')).toBe('91+');

    expect(NoteSeverityService.label('week', 'goat')).toBe('');
    expect(NoteSeverityService.label('month', 'goat')).toBe('');
    expect(NoteSeverityService.label('goat', 'butt')).toBe('');
    expect(NoteSeverityService.label()).toBe('');
  });

  it('should return last note severity', function () {
    expect(NoteSeverityService.severity('month', 0)).toBe('low');
    expect(NoteSeverityService.severity('month', 30)).toBe('low');
    expect(NoteSeverityService.severity('month', 31)).toBe('med-low');
    expect(NoteSeverityService.severity('month', 60)).toBe('med-low');
    expect(NoteSeverityService.severity('month', 61)).toBe('med');
    expect(NoteSeverityService.severity('month', 90)).toBe('med');
    expect(NoteSeverityService.severity('month', 91)).toBe('high');
    expect(NoteSeverityService.severity('month', 500)).toBe('high');

    expect(NoteSeverityService.severity('week', 0)).toBe('low');
    expect(NoteSeverityService.severity('week', 7)).toBe('low');
    expect(NoteSeverityService.severity('week', 8)).toBe('med-low');
    expect(NoteSeverityService.severity('week', 14)).toBe('med-low');
    expect(NoteSeverityService.severity('week', 15)).toBe('med');
    expect(NoteSeverityService.severity('week', 30)).toBe('med');
    expect(NoteSeverityService.severity('week', 31)).toBe('high');
    expect(NoteSeverityService.severity('week', 500)).toBe('high');
  });

  it('should return xmax', function () {
    expect(NoteSeverityService.xmax('month', 'low')).toBe(30);
    expect(NoteSeverityService.xmax('month', 'med-low')).toBe(60);
    expect(NoteSeverityService.xmax('month', 'med')).toBe(90);
    expect(NoteSeverityService.xmax('month', 'high')).toBe(120);

    expect(NoteSeverityService.xmax('week', 'low')).toBe(7);
    expect(NoteSeverityService.xmax('week', 'med-low')).toBe(14);
    expect(NoteSeverityService.xmax('week', 'med')).toBe(30);
    expect(NoteSeverityService.xmax('week', 'high')).toBe(60);
  });

  it('should return xmin', function () {
    expect(NoteSeverityService.xmin('month', 'low')).toBe(0);
    expect(NoteSeverityService.xmin('month', 'med-low')).toBe(30);
    expect(NoteSeverityService.xmin('month', 'med')).toBe(60);
    expect(NoteSeverityService.xmin('month', 'high')).toBe(90);

    expect(NoteSeverityService.xmin('week', 'low')).toBe(0);
    expect(NoteSeverityService.xmin('week', 'med-low')).toBe(7);
    expect(NoteSeverityService.xmin('week', 'med')).toBe(14);
    expect(NoteSeverityService.xmin('week', 'high')).toBe(30);
  });
});
