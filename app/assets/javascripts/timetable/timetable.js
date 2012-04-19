jQuery(document).ready(function($){

  // Every minute reloads page in terminal mode
  if ($('body.timetable.terminal').size())
    timer = setTimeout("window.location.reload(true)", 45000);

  $('body.timetable.terminal').click (function () {
    clearTimeout(timer);
    timer = setTimeout("window.location.reload(true)", 45000);
  });

  // Handles keyboard click
  $('.key').on('click', function () {
    var key   = $(this);
    var input = $('.timetable_input').first();

    if ( key.hasClass("backspace") ) {
      input.val(input.val().slice(0, -1));
    } else if ( key.hasClass("clear") ) {
      input.val("");
    } else if ( key.hasClass("whitespace") ) {
      input.val(input.val() + " ");
    } else {
      input.val(input.val() + $(this).text());
    }
    input.focus();
    input.trigger('input');
  });

  // Login menu
  $('.login_menu>li>a').on('click', function() {
    $('.login_menu menu').slideToggle();
    return false;
  });

  // Back button will move you back in history
  $('.back_button').on('click', function() {
    history.back();
    return false;
  });

});
