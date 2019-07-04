$(function() {
    function initializeMap(data) {
        
        var posts = $.parseJSON(data);
        //$('#display1').html(posts);
        
        //var geoJSON = L.geoJSON(posts);
        $('#display2').html(posts.geometry.coordinates[0]+","+posts.geometry.coordinates[1]);
        
        
        var map = L.map('map');
        var tangramLayer = Tangram.leafletLayer({
            scene: 'scene.yaml',
            attribution: '<a href="https://mapzen.com/tangram" target="_blank">Tangram</a> | &copy; OSM contributors'
        });
        tangramLayer.addTo(map);
        map.setView([posts.geometry.coordinates[0],posts.geometry.coordinates[1]],15);
        //map.setView([130.74542422,-35.65863174], 5);
        // map.setView([40.70531887544228, -74.00976419448853], 15);
        // map.setView([-42.52, 147.19], 15);
    };
    
    $.ajax({
        url: location.pathname + '.json',
        
        dataType: 'text',
        
        success: initializeMap
    });
    
});