'use strict';

angular.module('Dashboard').directive('histogram', [
  function () {
    return {
      restrict: 'E',
      scope: {
        barPadding: '=',
        data: '=',
        graphHeight: '=',
        graphWidth: '=',
        xmax: '=',
        xmin: '=',
        ymax: '=',
      },
      templateUrl: '/assets/templates/histogram.html',
      link: function (scope, element, attr) {
        var barLabelMin = 20, margin = {}, svg, x, xAxis, y, yAxis;

        scope.$watch('data', function () {
          if (! scope.data) {
            return;
          }

          if (svg) {
            svg.remove();
          }

          margin = { top: 0, right: 20, bottom: 20, left: 6 };

          x = d3.scale.linear()
            .domain([scope.xmin, scope.xmax])
            .range([0, scope.graphWidth]);

          y = d3.scale.linear()
            .range([scope.graphHeight, 0])
            .domain([0, scope.ymax || d3.max(scope.data, function(d) { return d; })]);

          xAxis = d3.svg.axis().scale(x).orient('bottom');
          yAxis = d3.svg.axis().scale(y).orient('left');

          svg = d3.select('#' + attr.id + ' svg')
            .attr('width', scope.graphWidth + margin.left + margin.right)
            .attr('height', scope.graphHeight + margin.top + margin.bottom)
            .append('g')
            .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

          // X-axis
          svg.append('g')
            .attr('class', 'x axis')
            .attr('transform', 'translate(0,' + scope.graphHeight + ')')
            .call(xAxis);

          // Bars
          svg.selectAll('.bar')
            .data(scope.data)
            .enter()
            .append('rect')
              .attr('class', 'bar')
              .attr('x', function(d, i) { return i * (scope.graphWidth / scope.data.length); })
              .attr('y', scope.graphHeight)
              .attr('width', scope.graphWidth / scope.data.length - scope.barPadding)
              .attr('height', 0)
              .transition()
              .duration(800)
              .attr('y', function(d) { return y(d); })
              .attr('height', function(d) { return scope.graphHeight - y(d); });

          // Bar labels
          svg.selectAll('.text')
            .data(scope.data)
            .enter() 
            .append('text')
            .text(function(d) { return d > 0 ? d : ''; })
            .classed('above', function(d) { return scope.graphHeight - y(d) <= barLabelMin; })
            .attr('x', function(d, i) {
              return i * (scope.graphWidth / scope.data.length) +
                (scope.graphWidth / scope.data.length - scope.barPadding) / 2;
            })
            .attr('fill-opacity', 0)
            .attr('y', scope.graphHeight)
            .transition()
            .delay(800)
            .duration(400)
            .attr('fill-opacity', 1)
            .attr('y', function(d) {
              // Bars are tall enough to have the count inside (below top of bar)
              if ( (scope.graphHeight - y(d)) > barLabelMin) {
                return y(d) + 16;
              }
              // Bars are too short and need the count above
              else {
                return y(d) - 7;
              }
            });
        });
      }
    };
  }
]);
