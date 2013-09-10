// Generated by CoffeeScript 1.6.3
(function() {
  (function($) {
    var init, options;
    options = {
      series: {
        stack: null
      }
    };
    init = function(plot) {
      var groupData;
      groupData = function(plot, s, data, datapoints) {
        var autoscale, format, i, interval, key, newpoints, point, points, ps, x;
        if ((s.group == null) || !s.group) {
          return;
        }
        interval = s.groupInterval;
        newpoints = {};
        i = 0;
        format = s.datapoints.format;
        if (!format) {
          format = [];
          format.push({
            x: true,
            number: true,
            required: true
          });
          format.push({
            y: true,
            number: true,
            required: true
          });
          if (s.bars.show || (s.lines.show && s.lines.fill)) {
            autoscale = !!((s.bars.show && s.bars.zero) || (s.lines.show && s.lines.zero));
            format.push({
              y: true,
              number: true,
              required: false,
              defaultValue: 0,
              autoscale: autoscale
            });
            if (s.bars.horizontal) {
              delete format[format.length - 1].y;
              format[format.length - 1].x = true;
            }
          }
          datapoints.format = format;
        }
        ps = format.length;
        s.xaxis.used = s.yaxis.used = true;
        while (i < data.length) {
          x = Math.round(data[i][0] / interval) * interval;
          if (ps == null) {
            ps = data[i].length;
          }
          if (newpoints[x] == null) {
            newpoints[x] = [];
            newpoints[x][0] = x;
            newpoints[x][1] = data[i][1];
            if ((s.bars != null) && s.bars) {
              newpoints[x][2] = 0;
            }
          } else {
            newpoints[x][1] += data[i][1];
          }
          i++;
        }
        points = [];
        for (key in newpoints) {
          point = newpoints[key];
          points = points.concat(point);
        }
        datapoints.points = points;
        datapoints.pointsize = ps;
      };
      plot.hooks.processRawData.push(groupData);
    };
    $.plot.plugins.push({
      init: init,
      options: options,
      name: 'group',
      version: '0.1'
    });
  })(jQuery);

}).call(this);

/*
//@ sourceMappingURL=jquery.flot.group.map
*/
