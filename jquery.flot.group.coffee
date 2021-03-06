(($) ->
  options =
    series:
      stack: null

  init = (plot) ->
    groupData = (plot, s, data, datapoints) ->
#      console.log 'group'
      return if not s.group? or not s.group
      interval = s.groupInterval
      newpoints = {}
      i = 0
      opt = s.xaxis.options
      offset = 0
      if opt.mode is 'time' and opt.timezone is 'browser'
        offset = (new Date()).getTimezoneOffset() * 60000

      format = s.datapoints.format
      if not format
        format = []
        format.push
          x: true
          number: true
          required: true
        format.push
          y: true
          number: true
          required: true

        if s.bars.show or (s.lines.show and s.lines.fill)
          autoscale = !!((s.bars.show && s.bars.zero) || (s.lines.show && s.lines.zero))
          format.push
            y: true
            number: true
            required: false
            defaultValue: 0
            autoscale: autoscale
          if s.bars.horizontal
            delete format[format.length - 1].y
            format[format.length - 1].x = true
        datapoints.format = format

      ps = format.length
      s.xaxis.used = s.yaxis.used = true

      while (i < data.length)
        x = Math.round((data[i][0] - offset) / interval) * interval + offset
        ps = data[i].length if not ps?
        if not newpoints[x]?
          newpoints[x] = []
          newpoints[x][0] = x
          newpoints[x][1] = data[i][1]
          newpoints[x][2] = 0 if s.bars? and s.bars
        else
          newpoints[x][1] += data[i][1]
        i++

      points = []
      for key, point of newpoints
        points = points.concat(point)
      datapoints.points = points
      datapoints.pointsize = ps

      return

    plot.hooks.processRawData.push groupData
    return

  $.plot.plugins.push
    init: init
    options: options
    name: 'group'
    version: '0.1'
  return)(jQuery)