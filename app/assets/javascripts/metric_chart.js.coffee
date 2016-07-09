url = "/organizations/:organization_id/projects/:project_id/branches/:branch_id/metrics/chart_data"

buildChart = (data, context) ->
  dataSet = {
    labels: data.labels,
    datasets: [
      {
          label: "Value",
          fill: false,
          lineTension: 0.1,
          backgroundColor: "rgba(75,192,192,0.4)",
          borderColor: "rgba(75,192,192,1)",
          borderCapStyle: 'butt',
          borderDash: [],
          borderDashOffset: 0.0,
          borderJoinStyle: 'miter',
          pointBorderColor: "rgba(75,192,192,1)",
          pointBackgroundColor: "#fff",
          pointBorderWidth: 1,
          pointHoverRadius: 5,
          pointHoverBackgroundColor: "rgba(75,192,192,1)",
          pointHoverBorderColor: "rgba(220,220,220,1)",
          pointHoverBorderWidth: 2,
          pointRadius: 1,
          pointHitRadius: 10,
          data: data.values,
      }
    ]
  }
  myLineChart = new Chart($(context).find('.chart'), {
    type: 'line',
    data: dataSet,
    options: { maintainAspectRatio: false }
  });

enableHistory = (context) ->
  history = $(context).find('.history')
  history.click () ->
    if ($(this).data('enabled'))
      $(this).data('enabled', false)
      history.find('i').css({'transform' : 'rotate(0deg)'});
      $(context).find('.chart-canvas').addClass('hidden')
    else
      $(this).data('enabled', true)
      history.find('i').css({'transform' : 'rotate(90deg)'});
      $(context).find('.chart-canvas').removeClass('hidden')

$(document).ready ->
  $('.metric').each (index, metric) ->
    organization = $(metric).data('organization')
    project = $(metric).data('project')
    branch = $(metric).data('branch')
    metricName = $(metric).data('name')
    console.log(metricName)

    if (organization && project && branch && metricName)

      enableHistory(metric)

      dataUrl = url.replace(':organization_id', organization)
                   .replace(':project_id', project)
                   .replace(':branch_id', branch)

      $.ajax({
        url: dataUrl
        type: 'GET'
        data: { metric_name: metricName }
        success: (data) ->
          buildChart(data, metric)
      })
