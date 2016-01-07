/** Search the England and Wales regions and counties using a map */
/* global window */

window.MapSearch = (function(
  $,
  _,
  Leaflet
)
{
  "use strict";

  var _selectedFeature = null;
  var _geojson;
  var _map;
  var _selectionCallback = null;

  var init = function( json ) {
    if (!_map) {
      _map = Leaflet.map( "map" ).setView( [53.0072, -2], 6 );
      _map.attributionControl.setPrefix( "Contains Ordnance Survey data &copy; Crown copyright 2016" );

      _geojson = Leaflet
        .geoJson( json,
                  {style: featureStyle,
                   onEachFeature: onEachFeature}
                )
        .addTo( _map );
    }
    else {
      resetSelection();
    }
  };

  var featureStyle = function() {
    return {
        fillColor: "#5A8006",
        weight: 1,
        opacity: 1,
        color: "white",
        dashArray: "3",
        fillOpacity: 0.7
    };
  };

  var highlightFeature = function( layer, colour ) {
    layer.setStyle({
        weight: 3,
        fillColor: "#C0C006",
        color: colour || "#686",
        dashArray: "",
        fillOpacity: 0.7
    });
  };

  var unHighlightFeature = function( feature ) {
    if (feature) {
      _geojson.resetStyle( feature );
    }
    if (_selectedFeature) {
      highlightFeature( _selectedFeature, "#e5ea08" );
    }
  };

  var locationName = function( feature ) {
    return feature.id || feature.properties.NAME.replace( / Euro Region/i, "" )
  };

  var onHighlightFeature = function( e ) {
    var feature = e.target.feature;

    highlightFeature( e.target );

    L.popup( {
        offset: new Leaflet.Point( 0, -10 ),
        autoPan: false
      } )
     .setLatLng(e.latlng)
     .setContent( locationName( feature ) )
     .openOn(_map);
  };

  var onUnhighlightFeature = function( e ) {
    unHighlightFeature( e.target );
  };

  var onSelectFeature = function( e ) {
    var oldSelectedFeature = _selectedFeature;
    _selectedFeature = e.target;

    unHighlightFeature( oldSelectedFeature );
    highlightFeature( _selectedFeature, "#e5ea08" );

    selectFeature( _selectedFeature );
  };

  var onEachFeature = function( feature, layer ) {
    layer.on({
        mouseover: onHighlightFeature,
        mouseout: onUnhighlightFeature,
        click: onSelectFeature
    });
  };

  var resetSelection = function() {
    var f = _selectedFeature;
    _selectedFeature = null;
    unHighlightFeature( f );
  };

  var map = function() {
    return _map;
  };

  var selectionCallback = function( fn ) {
    _selectionCallback = fn;
  };

  var selectFeature = function( feature ) {
    if (_selectionCallback) {
      _selectionCallback.call( null, locationName( feature.feature ) );
    }
  };

  return {
    init: init,
    map: map,
    selectionCallback: selectionCallback
  };
})(
  window.$,
  window.lodash,
  window.L
);
