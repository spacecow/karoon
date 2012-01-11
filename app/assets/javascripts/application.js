// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  $("#books_0_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_0_author_tokens").data("pre"),
    theme: ""
  });
  $("#books_0_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_0_category_tokens").data("pre"),
    theme: "facebook"
  });
});
