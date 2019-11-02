document.addEventListener("turbolinks:load", function() {
  (function() {
    let showAndHide = function() {
      if ($('#call_external').is(':checked')) {
        $('.external-calls-only').show()
        $('.internal-calls-only').hide()
      } else {
        $('.external-calls-only').hide()
        $('.internal-calls-only').show()
      }
    }

    $('#call_external').on('change', function(e) {
      showAndHide();
    });

    showAndHide();
  }).call(this);
})
