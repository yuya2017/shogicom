document.addEventListener('turbolinks:load', () => {
  let map;
  let geocoder;
  let marker = [];
  let infoWindow = [];
  const community = gon.community;

  function initMap(){
    geocoder = new google.maps.Geocoder()
    map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 35.5040528, lng: 138.6485391},
    zoom: 8
    });
    geocoder.geocode( { 'address': community.community_place }, function(results, status) {
      if (status == 'OK') {
        map.setCenter(results[0].geometry.location)
      };
    });
    geocoder.geocode( { 'address': community.community_place }, function(results, status) {
    if (status == 'OK') {
        marker = new google.maps.Marker({
            map: map,
            position: results[0].geometry.location
        });
    } else {
      alert('住所が存在しないためgoogle_mapに表示できませんでした。');
    }
    });
  };
  window.onload = function () {
      initMap();
  };
});
