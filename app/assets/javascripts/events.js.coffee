$(document).ready ->
  $('a.invite_link').bind 'ajax:success', ->
    alert('A calendar invite has been sent to your email!')
  $('a.invite_link').bind 'ajax:error', ->
    alert('Calendar invite failed to send.')
