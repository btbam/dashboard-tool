'use strict';

angular.module('Dashboard').directive('radialGraph', [
  '$timeout',
  function ($timeout) {
    return {
      restrict: 'E',
      scope: {
        animate: '=',
        idPrefix: '@',
        label: '@',
        pct: '=',
        radius: '=',
        strokeWidth: '=',
      },
      templateUrl: '/assets/templates/radial-graph.html',
      link: function (scope) {
        var startRadius = scope.radius ? scope.radius : 25;
        var startX = startRadius + scope.strokeWidth / 2;
        var startY = startRadius + scope.strokeWidth / 2;

        function getDelta (value1, value2) {
          var d = value1 - value2;
          if (d < 0) {
            d *= -1;
          }
          return d;
        }

        //http://stackoverflow.com/questions/5736398/how-to-calculate-the-svg-path-for-an-arc-of-a-circle
        function polarToCartesian (centerX, centerY, radius, angleInDegrees) {
          var angleInRadians = (angleInDegrees-90) * Math.PI / 180.0;
          return {
            x: centerX + (radius * Math.cos(angleInRadians)),
            y: centerY + (radius * Math.sin(angleInRadians))
          };
        }

        // adapted from http://stackoverflow.com/questions/5736398/how-to-calculate-the-svg-path-for-an-arc-of-a-circle
        function describeArc (x, y, radius, startAngle, endAngle) {
            var start = polarToCartesian(x, y, radius, endAngle);
            var end = polarToCartesian(x, y, radius, startAngle);
            var arcSweep = endAngle - startAngle <= 180 ? '0' : '1';

            // if creating a full circle, need to make two half-circle arcs and connect them
            if ((getDelta(start.y, end.y) <= 1) && (getDelta(start.x, end.x) <= 1)) {
              var mid = polarToCartesian(x, y, radius, 180);
              return [
                'M', start.x, start.y,
                'A', radius, radius, 0, arcSweep, 0, mid.x, mid.y,
                'M', mid.x, mid.y,
                'A', radius, radius, 0, arcSweep, 0, end.x, end.y
              ].join(' ');
            }

            return [
              'M', start.x, start.y,
              'A', radius, radius, 0, arcSweep, 0, end.x, end.y
            ].join(' ');
        }

        scope.drawArc = function (percent, id, x, y, radius) {
          if (percent > 0) {
            percent *= 0.01;
            var endAngle = percent * 360;
            var startAngle = 0;
            var path = document.getElementById(id);
            if (path) {
              path.setAttribute('d', describeArc(x, y, radius, startAngle, endAngle));
              path.setAttribute('stroke-width', scope.strokeWidth);
            }
          }
        };

        //http://jakearchibald.com/2013/animated-line-drawing-svg/
        scope.animateArc = function (id) {
          var path = document.getElementById(id);
          if (! path) {
            return;
          }
          var length = path.getTotalLength();
          // Clear any previous transition
          path.style.transition = path.style.WebkitTransition = 'none';
          path.style.visibility = 'visible';
          // Set up the starting positions
          path.style.strokeDasharray = length + ' ' + length;
          path.style.strokeDashoffset = -1 * length;
          // Trigger a layout so styles are calculated & the browser
          // picks up the starting position before animating
          path.getBoundingClientRect();
          // Define our transition
          path.style.transition = path.style.WebkitTransition = 'stroke-dashoffset 1s ease-in-out';
          // Go!
          path.style.strokeDashoffset = '0';
        };

        scope.$watch('pct', function () {
          scope.drawArc(100, scope.idPrefix + '-bgArc1', startX, startY, startRadius);
          scope.drawArc(scope.pct ? scope.pct : 0, scope.idPrefix + '-fillArc1', startX, startY, startRadius);

          if (scope.animate) {
            $timeout(function () { scope.animateArc(scope.idPrefix + '-fillArc1'); }, 0);
          }
        });
      }
    };
  }
]);
