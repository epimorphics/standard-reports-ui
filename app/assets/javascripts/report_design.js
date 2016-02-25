// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( function() {
  $(".c-back-action").on( "click", function( e ) {
    e.preventDefault();
    history.back();
  } );
} );
