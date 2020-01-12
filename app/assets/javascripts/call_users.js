document.addEventListener("turbolinks:load", function() {
  $(document).on('change', '.call_user_role_select', function(event) {
    let roleSelect = this;
    let callUserId = $(roleSelect).data().callUserId.toString();
    $(roleSelect).blur();

    if (['juror', 'director'].includes($(roleSelect).val())) {
      $(`#call_user_${callUserId}_category_ids`).removeClass('d-none');
    } else {
      $(`#call_user_${callUserId}_category_ids`).addClass('d-none'); // cleared on backend if submit
    }

    $(`#call_user_${callUserId}_category_ids_save`).removeClass('d-none');
  });
});
