(($) ->
  options =
    series:
      stack: null

  init = (plot) ->

    baseHash = null
    baseArray = null
    groupInterval = 0
    offset = 0

    countBases = (data) ->
      baseHash = {}
      baseArray = []
      data.forEach (s) ->
        if s.stack? and s.stack
          s.data.forEach (point) ->
            x = point[0]
            x = Math.round((x - offset) / groupInterval) * groupInterval + offset if groupInterval > 0
            if baseHash[x]
              baseHash[x].cnt++
            else
              baseHash[x] =
                cnt: 1
                pos: 0
                neg: 0
              baseArray.push x
      baseArray = baseArray.sort (a, b) -> a - b
#      console.log(baseArray)
      return

    stackData = (plot, s, datapoints) ->
#      console.log 'stack ' + s.label

      if s.group? and s.group
        groupInterval = s.groupInterval || 0
        opt = s.xaxis.options
        if opt.mode is 'time' and opt.timezone is 'browser'
          offset = (new Date()).getTimezoneOffset() * 60000

      countBases plot.getData() if not baseHash
      return if not s.stack? or s.stack is false

      points = datapoints.points
      pointsHash = {}
      ps = datapoints.pointsize

      # calculate offsets
      i = 0
      while i < points.length
        x = points[i]
        y = points[i+1]

        if y >= 0
          pointsHash[x] = [
            x
            y + baseHash[x].pos
            baseHash[x].pos
          ]
          baseHash[x].pos += y
        else
          pointsHash[x] = [
            x
            y + baseHash[x].neg
            baseHash[x].neg
          ]
          baseHash[x].neg += y

        i += ps
      # add missed points
      for x, base of baseHash
        if not pointsHash[x]?
          pointsHash[x] = [
            parseFloat(x)
            base.pos
            base.pos
          ]

      ps = 3

      # fill point array
      points = []
      i = 0
      while i < baseArray.length
        if pointsHash[baseArray[i]]?
          points = points.concat pointsHash[baseArray[i]]
        i++

#      console.log points
      datapoints.points = points
      datapoints.pointsize = ps
      return

    plot.hooks.processDatapoints.push stackData
    return

  $.plot.plugins.push
    init: init
    options: options
    name: 'stacksplit'
    version: '0.1'
  return
)(jQuery)