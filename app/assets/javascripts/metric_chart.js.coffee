
LINE_TENSION = 0.1
BORDER_DASH_OFFSET = 0.0
BACKGROUND_COLOR = "rgba(75,192,192,0.4)"
RED_BACKGROUND_COLOR = "rgba(255, 0, 0, 0.4)"
BORDER_COLOR = "rgba(75,192,192,1)"
RED_BORDER_COLOR = "rgba(255, 0, 0, 1)"
HOVER_BORDER_COLOR = "rgba(220,220,220,1)"
BORDER_WIDTH = 1
HOVER_RADIUS = 5
HOVER_BORDER_WIDTH = 2
POINT_RADIUS = 1
POINT_HIT_RADIUS = 10
POINT_BACKGROUND_COLOR = "#fff"
JOIN_STYLE = 'miter'
CAP_STYLE = 'butt'
LABEL = "Value"
MINIMUM_LABEL = "Minimum"
FILL = false

buildChart = (data, context) ->
  dataSet = {
    labels: data.labels,
    datasets: [
      {
          label: LABEL,
          fill: false,
          lineTension: LINE_TENSION,
          backgroundColor: BACKGROUND_COLOR,
          borderColor: BORDER_COLOR,
          borderCapStyle: CAP_STYLE,
          borderDash: [],
          borderDashOffset: BORDER_DASH_OFFSET,
          borderJoinStyle: JOIN_STYLE,
          pointBorderColor: BORDER_COLOR,
          pointBackgroundColor: POINT_BACKGROUND_COLOR,
          pointBorderWidth: BORDER_WIDTH,
          pointHoverRadius: HOVER_RADIUS,
          pointHoverBackgroundColor: BORDER_COLOR,
          pointHoverBorderColor: HOVER_BORDER_COLOR,
          pointHoverBorderWidth: HOVER_BORDER_WIDTH,
          pointRadius: POINT_RADIUS,
          pointHitRadius: POINT_HIT_RADIUS,
          data: data.values,
      },
      {
          label: MINIMUM_LABEL,
          fill: false,
          lineTension: LINE_TENSION,
          backgroundColor: RED_BACKGROUND_COLOR,
          borderColor: RED_BORDER_COLOR,
          borderCapStyle: CAP_STYLE,
          borderDash: [],
          borderDashOffset: BORDER_DASH_OFFSET,
          borderJoinStyle: JOIN_STYLE,
          pointBorderColor: BORDER_COLOR,
          pointBackgroundColor: POINT_BACKGROUND_COLOR,
          pointBorderWidth: BORDER_WIDTH,
          pointHoverRadius: HOVER_RADIUS,
          pointHoverBackgroundColor: BORDER_COLOR,
          pointHoverBorderColor: HOVER_BORDER_COLOR,
          pointHoverBorderWidth: HOVER_BORDER_WIDTH,
          pointRadius: POINT_RADIUS,
          pointHitRadius: POINT_HIT_RADIUS,
          data: data.minimum,
      }
    ]
  }
  myLineChart = new Chart($(context).find('.chart'), {
    type: 'line',
    data: dataSet,
    options: { maintainAspectRatio: false }
  });

loadChartData = (metric) ->
  dataUrl = $(metric).data('url')

  $.ajax({
    url: dataUrl
    type: 'GET'
    success: (data) ->
      $(metric).data('loaded', true)
      buildChart(data, metric)
  })

enableHistory = (context) ->
  history = $(context).find('.history')
  history.click () ->
    if ($(this).data('enabled'))
      $(this).data('enabled', false)
      history.find('i').css({'transform' : 'rotate(0deg)'});
      $(context).find('.chart-canvas').addClass('hidden')
    else
      $(this).data('enabled', true)
      if !$(context).data('loaded')
        loadChartData(context)
      history.find('i').css({'transform' : 'rotate(90deg)'});
      $(context).find('.chart-canvas').removeClass('hidden')

$(document).ready ->
  $('.metric').each (index, metric) ->
    url = $(metric).data('url')

    if (url)
      enableHistory(metric)
