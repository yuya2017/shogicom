document.addEventListener('turbolinks:load', () => {
let map
let geocoder
let marker = [];
let infoWindow = [];
const user = gon.user;
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

      }
    });

    geocoder.geocode( { 'address': community.community_place }, function(results, status) {
    if (status == 'OK') {
        marker = new google.maps.Marker({
            map: map,
            position: results[0].geometry.location
        });
        let id = community['id']
        infoWindow = new google.maps.InfoWindow({
        content: `<a href='/communities/${id}'>${community.community_place}</a>`
        });
        marker.addListener("click", function(){
            infoWindow.open(map, marker);
        });
    } else {
        alert('Geocode was not successful for the following reason: ' + status);
    }
    });
}
window.onload = function () {
    initMap();
}
});
