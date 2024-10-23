import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import "bootstrap-icons/font/bootstrap-icons.css"
import "stylesheets/application"
import "jquery"
import "./select2_init"


// Инициализация всех элементов с классом .collapse
document.addEventListener("turbo:load", () => {
  document.querySelectorAll('.collapse').forEach((collapseElement) => {
    new bootstrap.Collapse(collapseElement)
  })
})