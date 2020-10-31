document.addEventListener('turbolinks:load', () => {
let map
let geocoder
let marker = [];
let infoWindow = [];
const user = gon.user;
const communities = gon.communities;


function initMap(){
    geocoder = new google.maps.Geocoder()
    map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 35.5040528, lng: 138.6485391},
    zoom: 8
    });

    geocoder.geocode( { 'address': user.user_pref }, function(results, status) {
      if (status == 'OK') {
        map.setCenter(results[0].geometry.location)
      }
    });

    for (let i = 0; i < communities.length; i++) {
        geocoder.geocode( { 'address': communities[i].community_place }, function(results, status) {
        if (status == 'OK') {
            marker[i] = new google.maps.Marker({
                map: map,
                position: results[0].geometry.location
            });
            let id = communities[i]['id']
            infoWindow[i] = new google.maps.InfoWindow({
            content: `<a href='/communities/${id}'>${communities[i].community_place}</a>`
            });
            marker[i].addListener("click", function(){
                infoWindow[i].open(map, marker[i]);
            });
        } else {
            alert('Geocode was not successful for the following reason: ' + status);
        }
        });
    }
}
window.onload = function () {
    initMap();
}
});
