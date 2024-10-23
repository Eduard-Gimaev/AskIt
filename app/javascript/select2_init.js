import $ from "jquery";
import "select2/dist/js/select2";

$(document).on('turbolinks:load', function() {
  $('.js-multiple-select').each(function() {
    const $this = $(this);
    
    let opts = {
      width: '100%',
      allowClear: true,
      placeholder: $this.data('placeholder'),
      theme: 'bootstrap',
    };

    $this.select2(opts);
  });
});
