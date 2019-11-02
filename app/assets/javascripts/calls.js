document.addEventListener("turbolinks:load", function() {
  (function() {
    $('#call_external').on('change', function(e) {
      if ($('#call_external').is(':checked')) {
        $('.external-calls-only').show()
        $('.internal-calls-only').hide()
      } else {
        $('.external-calls-only').hide()
        $('.internal-calls-only').show()
      }
    });
  }).call(this);
})
