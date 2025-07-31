// app/assets/javascripts/application.js

document.addEventListener('DOMContentLoaded', function() {

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
    window.addEventListener('scroll', function() {
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
        if (button.textContent.includes('Agregar al Carrito')) {
            button.addEventListener('click', function(e) {
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

    // Contact form submission (demo)
    const contactForm = document.querySelector('#contacto form');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();

            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;

            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Enviando...';
            submitBtn.disabled = true;

            // Simulate form submission
            setTimeout(() => {
                submitBtn.innerHTML = '<i class="fas fa-check me-2"></i>¡Enviado!';
                submitBtn.classList.remove('btn-primary');
                submitBtn.classList.add('btn-success');

                // Reset form
                this.reset();

                // Show success message
                const alert = document.createElement('div');
                alert.className = 'alert alert-success mt-3';
                alert.innerHTML = '<i class="fas fa-check-circle me-2"></i>¡Mensaje enviado correctamente! Te contactaremos pronto.';
                this.appendChild(alert);

                // Reset button after 3 seconds
                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                    submitBtn.classList.remove('btn-success');
                    submitBtn.classList.add('btn-primary');
                    if (alert.parentNode) {
                        alert.remove();
                    }
                }, 3000);
            }, 2000);
        });
    }
});