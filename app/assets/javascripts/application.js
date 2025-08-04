// app/assets/javascripts/application.js
//= require rails-ujs
//= require_tree .

document.addEventListener('DOMContentLoaded', function () {

    // Smooth scrolling for navigation links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Navbar background change on scroll
    window.addEventListener('scroll', function () {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 100) {
            navbar.style.background = 'rgba(255, 255, 255, 0.98)';
            navbar.style.boxShadow = '0 4px 30px rgba(0, 0, 0, 0.15)';
        } else {
            navbar.style.background = 'rgba(255, 255, 255, 0.95)';
            navbar.style.boxShadow = '0 2px 20px rgba(0, 0, 0, 0.1)';
        }
    });

    // Add to cart functionality (demo)
    document.querySelectorAll('.btn-primary').forEach(button => {
        // Only apply to "Agregar al Carrito" buttons
        if (button.textContent.includes('Add to Cart')) {
            button.addEventListener('click', function (e) {
                e.preventDefault();

                // Animate button
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-check me-2"></i>¡Agregado!';
                this.classList.remove('btn-primary');
                this.classList.add('btn-success');

                // Update cart counter
                const cartBadge = document.querySelector('.badge');
                if (cartBadge) {
                    let currentCount = parseInt(cartBadge.textContent);
                    cartBadge.textContent = currentCount + 1;

                    // Animate cart icon
                    const cartIcon = cartBadge.closest('a');
                    cartIcon.style.transform = 'scale(1.2)';
                    setTimeout(() => {
                        cartIcon.style.transform = 'scale(1)';
                    }, 300);
                }

                // Reset button after 2 seconds
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.classList.remove('btn-success');
                    this.classList.add('btn-primary');
                }, 2000);
            });
        }
    });


    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});
