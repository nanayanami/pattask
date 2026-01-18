// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery3
//= require popper
//= require bootstrap


import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"

document.addEventListener("trix-attachment-add", (event) => {
  const editor = event.target && event.target.editor
  if (!editor) return
  // Add a line break after an attachment so typing doesn't replace it.
  editor.insertString("\n")
})
