
$(function() {
  $('#s3_uploader').S3Uploader(
    { 
      remove_completed_progress_bar: true,
      progress_bar_target: $('#uploads_container')
    }
  );
  $('#s3_uploader').bind('s3_upload_failed', function(e, content) {
    return alert(content.filename + ' failed to upload');
  });
  $('#s3_uploader').bind('s3_upload_complete', function(e, content) {
    return alert(content.filename + ' worked');
  });
});
