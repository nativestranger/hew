document.addEventListener("turbolinks:load", function() {
  (function() {
    $('#user_is_artist').on('change', function(e) {
      if ($('#user_is_artist').is(':checked')) {
        $('#user-artist-fields').show()
      } else {
        $('#user-artist-fields').hide()
      }
    });
  }).call(this);
})
