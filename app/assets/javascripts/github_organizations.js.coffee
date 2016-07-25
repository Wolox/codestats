load {
  controller: 'organizations_github_link'
  action: 'new'
}, (controller, action) ->
  timeout = () ->
    $('.loader').remove()
    $('.loading-error').removeClass('hidden')


  onOrganizationsRetrieved = (data) ->
    $('.loader').remove()
    data.jobs.forEach((org, index) ->
      template = $('.resource-template').children().clone()

      if org.avatar_url
        template.find('.avatar img').attr('src', org.avatar_url)
      else
        template.find('.avatar').addClass('hidden')

      name = template.find('.name')
      name.prepend(org.login)
      name.find("[name='github_link[github_name]']").val(org.login)
      name.find("[name='github_link[github_avatar_url]']").val(org.avatar_url)
      name.find("[name='github_link[github_url]']").val(org.url)

      $('#organizations').append(template)
    )

  $(document).ready ->
    url = $('#organizations').data('organizations-url')

    utils.exponentialBackoff(url, {
      timeout: timeout
      success: onOrganizationsRetrieved,
      error: timeout
    })
