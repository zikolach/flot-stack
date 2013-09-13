options =
  asBars:
    series:
      stack: true,
      group: true,
      groupInterval: 1,
      bars:
        show: true,
        align: 'center',
        lineWidth: 1
    shadowSize: 0
  asLines:
    series:
      stack: true
      group: true
      groupInterval: 1
      lines:
        show: true
        fill: true
        lineWidth: 1
      shadowSize: 0
  asTimeSeries:
    xaxis:
      mode: 'time'
      timezone: 'browser'
    series:
      stack: true
      group: true
      groupInterval: 24 * 60 * 60 * 1000
      bars:
        show: true
        align: 'center'
        lineWidth: 0
        barWidth: 24 * 60 * 60 * 1000
    shadowSize: 0

data = [
  {
    x: (n) -> n
    y: (n) -> Math.random() * 10 - (5)
  }
  {
    x: (n) -> n
    y: (n) -> Math.random() * 10
  }
  {
    x: (n) ->
      d = new Date()
      d.setDate(n + Math.random())
      d
    y: (n) -> Math.random() * 10 - (5)
  }
].map (f)->
  ['A', 'B', 'C', 'D'].map (s) ->
    {
      label: s
      data: [1..30].map (n) -> [f.x(n), f.y(n) ]
    }
$.plot $('#placeholder1'), $.extend(true, [], data[0]), options.asBars
$.plot $('#placeholder2'), $.extend(true, [], data[1]), options.asLines
$.plot $('#placeholder3'), $.extend(true, [], data[2]), options.asTimeSeries
