document.addEventListener("turbolinks:load", function() {
  (function() {
    let showOrHideExternalAndInteralFields = function() {
      if ($('#call_external').is(':checked')) {
        $('.external-calls-only').show();
        $('.internal-calls-only').hide();
      } else {
        $('.external-calls-only').hide();
        $('.internal-calls-only').show();
      }
    }

    let showOrHideVenueFields = function() {
      if ($('#call_call_type_id')[0] && $('#call_call_type_id')[0].value === "publication" || $('#call_call_type_id')[0].value === "competition") {
        $('#venue_fields').hide();
      } else {
        $('#venue_fields').show();
      }
    }

    $('#call_external').on('change', function(e) {
      showOrHideExternalAndInteralFields();
    });

    $('#call_call_type_id').on('change', function(e) {
      showOrHideVenueFields();
    });

    showOrHideExternalAndInteralFields();
    showOrHideVenueFields();
  }).call(this);
});
