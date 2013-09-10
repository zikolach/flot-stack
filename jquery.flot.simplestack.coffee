(($) ->
  options =
    series:
      stack: null

  init = (plot) ->

    baseHash = {}
    baseArray = []

    countBases = (plot, s, data, datapoints) ->
      console.log 'count ' + s.label
      if datapoints.pointsize?
        for x in datapoints.points by datapoints.pointsize
          if baseHash[x]
            baseHash[x].cnt++
          else
            baseHash[x] =
              cnt: 1
              pos: 0
              neg: 0
            baseArray.push x
      else
        data.forEach (point) ->
          x = point[0]
          if baseHash[x]
            baseHash[x]++
          else
            baseHash[x] =
              cnt: 1
              pos: 0
              neg: 0
            baseArray.push x
      baseArray = baseArray.sort (a, b) -> a > b
      return

    stackData = (plot, s, data, datapoints) ->
      console.log 'stack ' + s.label
      return if not s.stack? or s.stack is false

      points = datapoints.points
      pointsHash = {}
      ps = datapoints.pointsize

      # calculate offsets
      i = 0
      while i < points.length
        x = points[i]
        y = points[i+1]

        if y > 0
          pointsHash[x] = [
            x
            y + baseHash[x].pos
            baseHash[x].pos
          ]
          baseHash[points[i]].pos += y
        else
          pointsHash[x] = [
            x
            y + baseHash[x].neg
            baseHash[x].neg
          ]
          baseHash[points[i]].neg += y

        i += ps
      # add missed points
      for x, base of baseHash
        if not pointsHash[x]?
          pointsHash[x] = [
            x
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

      datapoints.points = points
      datapoints.pointsize = ps
      return

    plot.hooks.processRawData.push countBases
    plot.hooks.processRawData.push stackData
    return

  $.plot.plugins.push
    init: init
    options: options
    name: 'stacksplit'
    version: '0.1'
  return
)(jQuery)