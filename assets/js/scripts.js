document.addEventListener('DOMContentLoaded', function () {
    const hamburger = document.querySelector('.hamburger-menu');
    const navMenu = document.querySelector('.site-navigation');
    const closeNav = document.querySelector('.close-nav');
    const mobileBreakpoint = 768; // Mobile breakpoint in pixels

    function toggleMobileNav() {
        if (window.innerWidth <= mobileBreakpoint) {
            navMenu.classList.toggle('active');
        }
    }

    function handleResize() {
        if (window.innerWidth > mobileBreakpoint && navMenu.classList.contains('active')) {
            navMenu.classList.remove('active');
        }
    }

    hamburger.addEventListener('click', toggleMobileNav);
    closeNav.addEventListener('click', toggleMobileNav);
    window.addEventListener('resize', handleResize);
});
