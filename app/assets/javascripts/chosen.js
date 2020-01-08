document.addEventListener("turbolinks:load", function() {
  $('.chosen-select').chosen({
    allow_single_deselect: true,
    no_results_text: 'No results match',
    width: '100%'
  });
});
