document.addEventListener("turbolinks:load", function() {
  $( "#call_category_ids" ).select2({
    placeholder: "No Categories Selected",
    tags: true,
    theme: "bootstrap",
    createTag: function (params) {
      var term = $.trim(params.term);

      if (/^\s?\d+?\s?$/.test(term)) {
        return null;
      }

      return {
        id: term,
        text: term,
        newTag: true // add additional parameters
      }
    }
  });

  $(".call_user_category_ids").select2({
    placeholder: "No Categories",
    theme: "bootstrap"
  });
  $('.call_user_category_ids').on("select2:selecting", function(e) {
    let callUserId = e.currentTarget.dataset.callUserId;
    $(`#call_user_${callUserId}_category_ids_save`).removeClass('d-none');
  });
  $('.call_user_category_ids').on("select2:unselect", function(e) {
    let callUserId = e.currentTarget.dataset.callUserId;
    $(`#call_user_${callUserId}_category_ids_save`).removeClass('d-none');
  });

  $( "#entry_searcher_category_ids" ).select2({
    placeholder: "No Category Filter",
    theme: "bootstrap",
  });

  $( "#entry_searcher_status_ids" ).select2({
    placeholder: "No Status Filter",
    theme: "bootstrap",
  });
});
