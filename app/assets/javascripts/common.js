jQuery(document).ready(function($) {
  $('.semester_change+button').remove();
  $('.semester_change').change(function() {
    $(this).parent().submit();
  });
});
