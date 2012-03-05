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
  var locale_id = "#translation_locale_token";
  $(locale_id).tokenInput($(locale_id).data("url"), {
    crossDomain: false,
    allowCreation: true,
    tokenLimit: 1,
    theme: ""
  });
  var author_id = "#book_author_tokens";
  $(author_id).tokenInput($(author_id).data("url"), {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    theme: ""
  });
  var category_id = "#book_category_tokens_en";
  $(category_id).tokenInput($(category_id).data("url"), {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    theme: "facebook"
  });
  var category_id = "#book_category_tokens_ir";
  $(category_id).tokenInput($(category_id).data("url"), {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    theme: "facebook"
  });

  for(i=0; i<10; i++){
    var author_id = "#books_"+i+"_author_tokens";
    $(author_id).tokenInput($(author_id).data("url"), {
      crossDomain: false,
      preventDuplicates: true,
      allowCreation: true,
      theme: ""
    });

    var category_id = "#books_"+i+"_category_tokens_en";
    $(category_id).tokenInput($(category_id).data("url"), {
      crossDomain: false,
      preventDuplicates: true,
      allowCreation: true,
      theme: "facebook"
    });

    var category_id = "#books_"+i+"_category_tokens_ir";
    $(category_id).tokenInput($(category_id).data("url"), {
      crossDomain: false,
      preventDuplicates: true,
      allowCreation: true,
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
