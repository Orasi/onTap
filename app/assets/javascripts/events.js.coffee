$(document).ready ->
  $('a.invite_link').bind 'ajax:success', ->
    alert('Calendar invite sent to your email!')
  $('a.invite_link').bind 'ajax:error', ->
    alert('Calendar invite failed to send.')