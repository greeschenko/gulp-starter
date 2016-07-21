function doanim() {
    $('h1 span').each(function(i) {
        var el = $(this);
        setTimeout(function() {
            el.toggleClass('active');
        }, 500 * i);
    });
}
$(window).ready(function() {
    setInterval(function() {
        doanim();
    }, 3000);
});
