document.addEventListener("turbolinks:load", function() {
  $( "#call_category_ids" ).select2({
    tags: true,
    theme: "bootstrap"
  });
});
