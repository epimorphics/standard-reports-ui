document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll('details').forEach(function(detail) {
      var summary = detail.querySelector('summary');
      var span = summary.querySelector('span.summary');
  
      detail.addEventListener('toggle', function() {
        var isHidden = !detail.open;
        span.textContent = span.textContent.replace(
          isHidden ? 'close' : 'view', 
          isHidden ? 'view' : 'close'
        );
      });
    });
});

  