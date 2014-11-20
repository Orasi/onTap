# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

text_query = "";
$(document).ready ->
  animate_crossfade = (obj, text) ->
    obj.animate {'opacity': 0}, 1000, ->
      $(this).text(text)
    obj.animate {'opacity': 1}, 1000

  $('.create_env').click ->
    labs_id = $(this).attr('id')
    disable_input(labs_id);
    create_environment(labs_id)


  disable_input = (labs_id) ->
    text_query = '#' + labs_id
    animate_crossfade $(text_query), 'In Queue...'

    $('.create_env').addClass('disabled')
    $('.spin_button').addClass('disabled')
    $('#load_' + labs_id ).css('visibility', 'visible')

  create_environment = (labs_id) ->
    post_url = '/labs/' + labs_id
    $.post post_url  , (data) ->
      env_id = data.id
      $('#patient_' + labs_id).fadeIn()
      get_status(env_id, labs_id)

  get_status = (env_id, labs_id) ->
    current_time = new Date()/1000
    status_poll = window.setInterval ->
      $.getJSON '/labs/' + env_id + '/status', (data) ->
        animate_crossfade $(text_query), data.status + '...'

        if data.status == 'running'
          window.location.href = '/labs/' + env_id + '/manage'

        else if (new Date()/1000) - current_time > 300
          $('#patient_' + labs_id).fadeOut()
          clearInterval(status_poll)
          $('#loading').fadeOut()
          $('#create_env').fadeOut()
          $('#timeout').fadeIn()

    , 10000
  Window.disable_input = disable_input
  Window.get_status = get_status



