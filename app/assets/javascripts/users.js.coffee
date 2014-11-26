$(document).ready ->
  $(".admin_checkbox").on "change", ->
    $(this).parent().submit()