import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import "bootstrap-icons/font/bootstrap-icons.css"
import "stylesheets/application"

// Инициализация всех элементов с классом .collapse
document.addEventListener("turbo:load", () => {
  document.querySelectorAll('.collapse').forEach((collapseElement) => {
    new bootstrap.Collapse(collapseElement)
  })
})