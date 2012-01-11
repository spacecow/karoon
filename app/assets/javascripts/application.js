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

  $("#books_1_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_1_author_tokens").data("pre"),
    theme: ""
  });
  $("#books_1_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_1_category_tokens").data("pre"),
    theme: "facebook"
  });

  $("#books_2_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_2_author_tokens").data("pre"),
    theme: ""
  });
  $("#books_2_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_2_category_tokens").data("pre"),
    theme: "facebook"
  });

  $("#books_3_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_3_author_tokens").data("pre"),
    theme: ""
  });
  $("#books_3_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_3_category_tokens").data("pre"),
    theme: "facebook"
  });

  $("#books_4_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_4_author_tokens").data("pre"),
    theme: ""
  });
  $("#books_4_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_4_category_tokens").data("pre"),
    theme: "facebook"
  });

  $("#books_5_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_5_author_tokens").data("pre"),
    theme: ""
  });
  $("#books_5_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_5_category_tokens").data("pre"),
    theme: "facebook"
  });

  $("#books_6_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_6_author_tokens").data("pre"),
    theme: ""
  });
  $("#books_6_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_6_category_tokens").data("pre"),
    theme: "facebook"
  });

  $("#books_7_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_7_author_tokens").data("pre"),
    theme: ""
  });
  $("#books_7_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_7_category_tokens").data("pre"),
    theme: "facebook"
  });

  $("#books_8_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_8_author_tokens").data("pre"),
    theme: ""
  });
  $("#books_8_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_8_category_tokens").data("pre"),
    theme: "facebook"
  });

  $("#books_9_author_tokens").tokenInput("/authors.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_9_author_tokens").data("pre"),
    theme: ""
  });
  $("#books_9_category_tokens").tokenInput("/categories.json", {
    crossDomain: false,
    preventDuplicates: true,
    allowCreation: true,
    prePopulate: $("#books_9_category_tokens").data("pre"),
    theme: "facebook"
  });
});
