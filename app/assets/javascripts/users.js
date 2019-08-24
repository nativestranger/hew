document.addEventListener("turbolinks:load", function() {
  (function() {
    $('#user_is_artist').on('change', function(e) {
      if ($('#user_is_artist').is(':checked')) {
        $('#user-artist-website-form-group').show()
      } else {
        $('#user-artist-website-form-group').hide()
      }
    });
  }).call(this);
})
