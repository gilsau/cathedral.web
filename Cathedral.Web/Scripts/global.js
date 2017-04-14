var lat = 0;
var long = 0;
var city = '';
var state = '';
var appId = '1ea0b461fdc1d40eae0efee1f39c71d8';
var openWeatherUrl = '//api.openweathermap.org/data/2.5/weather';

$(document).ready(function () {

    //match height w/width to make complete square
    $('.square, .squareOverlay').each(function () {
        var box = $(this);
        box.css('height', (Math.abs(box.css('width').replace('px', ''))/2) + 'px');
    });

    getLocation();
});

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.watchPosition(showPosition);
    } else {
        x.innerHTML = "Geolocation is not supported by this browser.";
    }
}

function showPosition(position) {
    lat = position.coords.latitude;
    long = position.coords.longitude;

    //show coords on page
    $('#coords').html(Number(lat).toFixed(2) + ', ' + Number(long).toFixed(2));

    //Get address from google maps
    var sFullUrl = '//maps.googleapis.com/maps/api/geocode/json?latlng=' + lat + ',' + long;
    $.get(sFullUrl, function (data) {

        //save city/state for weather query later
        city = data.results[1].address_components[0].long_name;
        state = data.results[1].address_components[2].short_name;

        //show address on page
        $('#address').html(data.results[0].formatted_address);

        //get weather from Open Weather API
        getWeather();
    });
}

function getWeather() {
    //var sFullUrl = openWeatherUrl + '?lat=' + lat + '&lon=' + long + '&appid=' + appId + '&units=imperial';
    var sFullUrl = openWeatherUrl + '?q=' + city + ',' + state + '&appid=' + appId + '&units=imperial';

    $.get(sFullUrl, function (data) {
        $('#weather').html('<div>' + data.weather[0].description + '</div><img src=' + 'http://openweathermap.org/img/w/' + data.weather[0].icon + ".png" + ' style="height:50px;" />');
        $('#city').html(data.name.toUpperCase());
        $('#temp').html(Math.round(data.main.temp, 0) + '&deg;');
        $('#wind').html(Math.round(data.wind.speed, 0) + ' mph');
        $('#humid').html(Math.round(data.main.humidity, 0) + '%');
    });
}