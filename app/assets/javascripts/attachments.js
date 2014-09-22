
$(function() {
  $('#s3_uploader').S3Uploader(
    { 
      remove_completed_progress_bar: false,
      progress_bar_target: $('#uploads_container')
    }
  );
  $('#s3_uploader').bind('s3_upload_failed', function(e, content) {
    $('#upload_' + content.unique_id).find('.progress').fadeOut('slow', function(){
      $('#upload_' + content.unique_id).append('<span style="color:red" class="glyphicon glyphicon-remove-sign"></span> File Failed to Upload. Please Contact System Administrator')
    });
  });
  $('#s3_uploader').bind('s3_upload_complete', function(e, content) {
    $('#upload_' + content.unique_id).find('.progress').fadeOut('slow', function(){
      $('#upload_' + content.unique_id).append('<span style="color:green" class="glyphicon glyphicon-ok-sign"></span>')
    });
  });
});
