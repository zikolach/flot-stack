(($) ->
  options =
    series:
      stack: null

  init = (plot) ->

    posOffsets = []
    negOffsets = []

    stackData = (plot, series, datapoints) ->
#      debugger
      return if not series.stack? or series.stack is false

      points = datapoints.points
      newpoints = []
      ps = datapoints.pointsize
      i = 0

      while i < points.length
        posOffsets[i] = 0 if not posOffsets[i]?
        negOffsets[i] = 0 if not negOffsets[i]?


        newpoints.push points[i]
        if points[i+1] > 0
          newpoints.push points[i+1] + posOffsets[i]
          newpoints.push posOffsets[i]
        else
          newpoints.push points[i+1] + negOffsets[i]
          newpoints.push negOffsets[i]

        if points[i+1] > 0
          posOffsets[i] += points[i+1]
        else
          negOffsets[i] += points[i+1]

        i += ps
#      console.log points
#      console.log newpoints
#      console.log plot.getData()
#      console.log series
      datapoints.points = newpoints
      return

    plot.hooks.processDatapoints.push(stackData);
    return

  $.plot.plugins.push
    init: init
    options: options
    name: 'stacksplit'
    version: '0.1'
  return
)(jQuery)