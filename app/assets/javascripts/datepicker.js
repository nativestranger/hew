document.addEventListener("turbolinks:load", function() {

  // $.fn.datetimepicker.Constructor.Default = $.extend({}, $.fn.datetimepicker.Constructor.Default, {
  //
  // });

  $('.terminus-dominus').click(function() {
    $(this).datetimepicker('show');
  });
  $('.terminus-dominus').focus(function() {
    $(this).datetimepicker('show');
  });
  $('.terminus-dominus').blur(function() {
    $(this).datetimepicker('hide');
  });
});
