document.addEventListener("turbolinks:load", function() {
  $(document).on('change', '.call_user_role_select', function(event) {
    let callUserId = $(this).data().callUserId.toString();

    $(this).blur();

    $.ajax({
      type: 'PUT',
      url: window.location.pathname + '/' + callUserId, // 'calls/x/call_users/y'
      data: {
        call_user: {
          role: $(this).val()
        },
        authenticity_token: App.getMetaContent("csrf-token")
      },
      dataType: 'json',
      success: function(data) {
        let tdId = '#call_user_' + callUserId + '_role_select_td';
        $(tdId).removeClass('bg-white');
        $(tdId).addClass('bg-success');
        setTimeout(function() {
          $(tdId).addClass('bg-white');
          $(tdId).removeClass('bg-success');
        }, 200);
      },
      error: function(data) {
        alert('Something went wrong. Please contact us if this persists.');
        location.reload();
      }
    });
  });
});
