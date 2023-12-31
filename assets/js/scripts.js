document.addEventListener('DOMContentLoaded', function () {
    const hamburger = document.querySelector('.hamburger-menu');
    const navMenu = document.querySelector('.site-navigation');
    const mobileBreakpoint = 768; // Mobile breakpoint in pixels

    function toggleMobileNav() {
        if (window.innerWidth <= mobileBreakpoint) {
            navMenu.style.display = navMenu.style.display === 'flex' ? 'none' : 'flex';
        }
    }

    function handleResize() {
        if (window.innerWidth > mobileBreakpoint) {
            navMenu.style.display = ''; // Reset the display property
        }
    }

    hamburger.addEventListener('click', toggleMobileNav);
    window.addEventListener('resize', handleResize);
});
