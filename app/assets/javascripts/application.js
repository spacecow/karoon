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
  $("#translation_locale_token").tokenInput("/locales.json", {
    crossDomain: false,
    allowCreation: true,
    tokenLimit: 1,
    prePopulate: $("#translation_locale_token").data("pre"),
    theme: ""
  });
  $("#book_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#book_author_tokens").data("pre"),
    theme: ""
  });
  $("#book_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#book_category_tokens").data("pre"),
    theme: "facebook"
  });

  for(i=0; i<10; i++){
    var author_id = "#books_"+i+"_author_tokens";
    $(author_id).tokenInput("/authors.json", {
      crossDomain: false,
      preventDuplicates: true,
      allowCreation: true,
      prePopulate: $(author_id).data("pre"),
      theme: ""
    });

    var category_id = "#books_"+i+"_category_tokens";
    $(category_id).tokenInput("/categories.json", {
      crossDomain: false,
      preventDuplicates: true,
      allowCreation: true,
      prePopulate: $(category_id).data("pre"),
      theme: "facebook"
    });
  }

  for(i=1; i<10; i++){
    $("div.hide").hide();
  }

  $("a#add_book_form").click(function(){
    var i = $("div.book").filter(":visible").size();
    $("div#book_"+i).show();
  });
});
