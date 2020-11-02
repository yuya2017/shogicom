document.addEventListener("turbolinks:load", function(){
$('.container-fluid').on('click',function() {
    if($('div').hasClass('profile_link') && $('div').hasClass('d-block')){
      $('.profile_link').removeClass('d-block');
    }
  })
});

document.addEventListener("turbolinks:load", function(){
  $('.icon_image').on('click',function() {
    var img_id = $(this).data('id');
    var profile_id = ".profile-" + img_id;
    if(!$(profile_id).hasClass("d-block")) {
      $(profile_id).addClass('d-block');
      if($('.profile_link.d-block').length < 2){
      return false;
      }
    }
  })
});
