load {
  controller: 'projects'
  action: 'new'
}, (controller, action) ->

  timeout = () ->
    $('.loader').remove()
    $('.loading-error').removeClass('hidden')


  onProjectsRetrieved = (data) ->
    $('.loader').remove()
    console.log(data)
    data.jobs.forEach((project, index) ->
      template = $('.resource-template').children().clone()

      name = template.find('.name')
      name.prepend(project.name)
      name.find("[name='name']").val(project.full_name)

      $('#projects').append(template)
    )

  $(document).ready ->
    url = $('#projects').data('projects-url')

    utils.exponentialBackoff(url, {
      timeout: timeout
      success: onProjectsRetrieved,
      error: timeout
    })
