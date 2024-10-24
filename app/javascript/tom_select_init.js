import TomSelect from "tom-select";

console.log("Tom Select script loaded");

document.addEventListener("turbo:load", () => {
  console.log("Turbo:load event triggered");
  document.querySelectorAll('.js-multiple-select').forEach((element) => {
    console.log("Initializing Tom Select for element:", element);
    new TomSelect(element, {
      plugins: ['remove_button'],
      create: false,
      allowClear: true,
      placeholder: element.dataset.placeholder,
      theme: 'bootstrap5',
    });
  });
});