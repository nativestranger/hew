document.addEventListener("turbolinks:load", function() {
  $( "#call_category_ids" ).select2({
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
});
