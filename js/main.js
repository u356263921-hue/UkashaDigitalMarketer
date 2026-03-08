// Premium Custom Cursor Logic
const cursorDot = document.querySelector('.cursor-dot');
const cursorOutline = document.querySelector('.cursor-outline');

if (cursorDot && cursorOutline) {
    window.addEventListener('mousemove', (e) => {
        const posX = e.clientX;
        const posY = e.clientY;

        // Dot follows strictly
        cursorDot.style.left = `${posX}px`;
        cursorDot.style.top = `${posY}px`;

        // Outline lags slightly for smooth effect
        cursorOutline.animate({
            left: `${posX}px`,
            top: `${posY}px`
        }, { duration: 500, fill: "forwards" });
    });

    const interactiveElements = document.querySelectorAll('a, button, input, select, textarea, .project-card, .service-mini-card, .faq-header');

    interactiveElements.forEach(el => {
        el.addEventListener('mouseenter', () => {
            cursorOutline.classList.add('hover');
            cursorDot.style.transform = 'translate(-50%, -50%) scale(0.5)';
        });
        el.addEventListener('mouseleave', () => {
            cursorOutline.classList.remove('hover');
            cursorDot.style.transform = 'translate(-50%, -50%) scale(1)';
        });
    });
}

// Ensure sticky header functionality works seamlessly
const header = document.querySelector('header');
if (header) {
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    });

    // Run once on load to catch mid-page refreshes
    if (window.scrollY > 50) {
        header.classList.add('scrolled');
    }
}

// Active link highlighting for multi-page approach
const currentLocation = location.href;
const navLinks = document.querySelectorAll('.nav-links a');
const navLength = navLinks.length;

for (let i = 0; i < navLength; i++) {
    // Check if the current location includes the href of the link
    if (currentLocation.includes(navLinks[i].getAttribute('href'))) {
        navLinks[i].className = "active";
    }
}

// Scroll animation observer
const observerOptions = {
    threshold: 0.1,
    rootMargin: "0px 0px -50px 0px"
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

const animateElements = document.querySelectorAll('.animate-on-scroll');
animateElements.forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'all 0.8s cubic-bezier(0.2, 0.8, 0.2, 1)';
    observer.observe(el);
});

// Mobile menu toggle
const mobileToggle = document.querySelector('.mobile-toggle');
const navContainer = document.querySelector('.nav-links');

if (mobileToggle && navContainer) {
    mobileToggle.addEventListener('click', () => {
        navContainer.classList.toggle('active');
    });

    // Close menu when a link is clicked (specifically for mobile)
    const navItems = navContainer.querySelectorAll('a');
    navItems.forEach(item => {
        item.addEventListener('click', () => {
            navContainer.classList.remove('active');
        });
    });
}

// Exit Intent Popup Logic
const exitPopup = document.getElementById('exitPopup');
const closeExitPopup = document.getElementById('closeExitPopup');
let hasShownExitPopup = false;

if (exitPopup && closeExitPopup) {
    // Show popup when mouse leaves viewport (towards the top)
    document.addEventListener('mouseleave', (e) => {
        if (e.clientY <= 0 && !hasShownExitPopup) {
            exitPopup.classList.add('show');
            hasShownExitPopup = true;

            // Set cookie/localstorage so it doesn't annoy returning users
            sessionStorage.setItem('exit_popup_shown', 'true');
        }
    });

    // Check if already shown in this session
    if (sessionStorage.getItem('exit_popup_shown') === 'true') {
        hasShownExitPopup = true;
    }

    // Close handlers
    closeExitPopup.addEventListener('click', () => {
        exitPopup.classList.remove('show');
    });

    exitPopup.addEventListener('click', (e) => {
        if (e.target === exitPopup) {
            exitPopup.classList.remove('show');
        }
    });
}

// FAQ Accordion Logic
const faqHeaders = document.querySelectorAll('.faq-header');
faqHeaders.forEach(header => {
    header.addEventListener('click', () => {
        const body = header.nextElementSibling;
        const icon = header.querySelector('i');

        // Toggle active class and display
        if (body.style.display === 'block') {
            body.style.display = 'none';
            icon.style.transform = 'rotate(0deg)';
        } else {
            // Close all others
            document.querySelectorAll('.faq-body').forEach(b => b.style.display = 'none');
            document.querySelectorAll('.faq-header i').forEach(i => i.style.transform = 'rotate(0deg)');

            // Open this one
            body.style.display = 'block';
            icon.style.transform = 'rotate(180deg)';
        }
    });
});

// Multi-Step Form Logic
const multiStepForm = document.getElementById('multiStepForm');
if (multiStepForm) {
    const steps = document.querySelectorAll('.form-step');
    const nextBtns = document.querySelectorAll('.next-step');
    const prevBtns = document.querySelectorAll('.prev-step');
    const stepText = document.getElementById('currentStepText');
    const progressBar = document.getElementById('formProgressBar');
    let currentStep = 0;

    function updateFormSteps() {
        steps.forEach((step, index) => {
            if (index === currentStep) {
                step.style.display = 'block';
                setTimeout(() => step.style.opacity = '1', 10);
            } else {
                step.style.display = 'none';
                step.style.opacity = '0';
            }
        });

        // Update Text and Progress Bar
        const stepNum = currentStep + 1;
        if (stepText) stepText.textContent = stepNum;

        if (progressBar) {
            if (stepNum === 1) progressBar.style.width = '33%';
            if (stepNum === 2) progressBar.style.width = '66%';
            if (stepNum === 3) progressBar.style.width = '100%';
        }
    }

    nextBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            // Basic validation for the current step before moving on
            const currentInputs = steps[currentStep].querySelectorAll('input[required], select[required], textarea[required]');
            let isValid = true;

            currentInputs.forEach(input => {
                if (!input.checkValidity()) {
                    input.reportValidity();
                    isValid = false;
                }
            });

            if (isValid && currentStep < steps.length - 1) {
                currentStep++;
                updateFormSteps();
            }
        });
    });

    prevBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            if (currentStep > 0) {
                currentStep--;
                updateFormSteps();
            }
        });
    });

    multiStepForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const submitBtn = multiStepForm.querySelector('button[type="submit"]');
        submitBtn.innerHTML = 'Sending... <i class="ph-bold ph-spinner"></i>';

        // Simulate API call
        setTimeout(() => {
            multiStepForm.innerHTML = `
                <div style="text-align: center; padding: 2rem 0;">
                    <i class="ph-fill ph-check-circle" style="font-size: 5rem; color: #4CAF50; margin-bottom: 1rem;"></i>
                    <h3>Request Received</h3>
                    <p style="color: var(--text-gray);">A strategist will contact you within 24 hours.</p>
                </div>
            `;
            if (progressBar) progressBar.style.background = '#4CAF50';
        }, 1500);
    });
}

