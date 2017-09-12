$(function () {
	$('.mobile-link:not(.dropdown-toggle)').bind('click touchstart', function () {
        $('.navbar-toggle:visible').click();
	});
});