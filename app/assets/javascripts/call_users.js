document.addEventListener("turbolinks:load", function() {
  $(document).on('change', '.call_user_role_select', function(event) {
    let roleSelect = this;
    let callUserId = $(roleSelect).data().callUserId.toString();
    $(roleSelect).blur();

    $.ajax({
      type: 'PUT',
      url: window.location.pathname + '/' + callUserId, // 'calls/x/call_users/y'
      data: {
        call_user: { role: $(roleSelect).val() },
        authenticity_token: App.getMetaContent("csrf-token")
      },
      dataType: 'json',
      success: function(data) {
        $(roleSelect).removeClass('bg-white');
        $(roleSelect).addClass('bg-success text-white');
        setTimeout(function() {
          $(roleSelect).addClass('bg-white');
          $(roleSelect).removeClass('bg-success text-white');
        }, 100);
      },
      error: function(data) {
        alert('Something went wrong. Please contact us if this persists.');
        location.reload();
      }
    });
  });
});
