import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import "bootstrap-icons/font/bootstrap-icons.css"
import "stylesheets/application"
import "./tom_select_init"; // Correct import for tom_select_init.js in the same directory
console.log("Application.js is loaded");
// Initialize all elements with the .collapse class
document.addEventListener("turbo:load", () => {
  document.querySelectorAll('.collapse').forEach((collapseElement) => {
    new bootstrap.Collapse(collapseElement)
  })
})