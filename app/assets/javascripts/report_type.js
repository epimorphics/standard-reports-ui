document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll('details').forEach(function(detail) {
      const summary = detail.querySelector('summary');
      const span = summary.querySelector('span.summary');
  
      detail.addEventListener('toggle', function() {
        const isHidden = !detail.open;
        span.textContent = span.textContent.replace(
          isHidden ? 'close' : 'view', 
          isHidden ? 'view' : 'close'
        );
      });
    });
});

  