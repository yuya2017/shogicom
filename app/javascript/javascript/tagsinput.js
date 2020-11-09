document.addEventListener("turbolinks:load", function(){
  $('.tagsinput').tagsInput();
});

document.addEventListener("turbolinks:load", function(){
  id = $('.tags_search').attr('id') + "_tagsinput"
  $('#' + id).on('click',function() {
    $('#default_text').addClass('d-none');
    return false
  });
});

document.addEventListener("turbolinks:load", function(){
  if($('.tags_search').length){
    id = $('.tags_search').attr('id') + "_tagsinput"
    $('.container-fluid').on('click',function() {
      if(!($('#' + id).children('span')).length){
        $('#default_text').removeClass('d-none');
      };
    });
  };
});

document.addEventListener("turbolinks:load", function(){
  if($('.tags_search').length){
    id = $('.tags_search').attr('id') + "_tagsinput"
    if(!($('#' + id).children('span')).length){
      $('#default_text').removeClass('d-none');
    };
  };
});
