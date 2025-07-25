// Language management
let currentLanguage = 'en';

function toggleLanguage() {
    currentLanguage = currentLanguage === 'en' ? 'zh' : 'en';
    updateLanguage();
    
    // Update button text
    const langButton = document.querySelector('.lang-switch');
    langButton.textContent = currentLanguage === 'en' ? '中文' : 'English';
}

function updateLanguage() {
    // Update all elements with data-en and data-zh attributes
    const elements = document.querySelectorAll('[data-en][data-zh]');
    elements.forEach(element => {
        const text = element.getAttribute(`data-${currentLanguage}`);
        if (text) {
            element.textContent = text;
        }
    });
    
    // Update page title
    document.title = currentLanguage === 'en' 
        ? 'AIMBTI - AI-Powered MBTI Personality Test'
        : 'AIMBTI - AI驱动的MBTI人格测试';
}

// Mobile menu toggle
function toggleMobileMenu() {
    const navLinks = document.querySelector('.nav-links');
    navLinks.classList.toggle('mobile-active');
}

// Smooth scrolling for navigation links
document.addEventListener('DOMContentLoaded', function() {
    // Initialize language based on browser settings
    const browserLang = navigator.language || navigator.userLanguage;
    if (browserLang.includes('zh')) {
        toggleLanguage();
    }
    
    // Smooth scrolling
    const links = document.querySelectorAll('a[href^="#"]');
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                const navHeight = document.querySelector('.navbar').offsetHeight;
                const targetPosition = targetElement.offsetTop - navHeight - 20;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Intersection Observer for animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    // Observe feature cards and screenshot items
    const animatedElements = document.querySelectorAll('.feature-card, .screenshot-item, .download-card');
    animatedElements.forEach(el => {
        observer.observe(el);
    });
    
    // Add animation styles
    const style = document.createElement('style');
    style.textContent = `
        .feature-card, .screenshot-item, .download-card {
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.6s ease, transform 0.6s ease;
        }
        
        .feature-card.animate-in, .screenshot-item.animate-in, .download-card.animate-in {
            opacity: 1;
            transform: translateY(0);
        }
        
        .feature-card:nth-child(1) { transition-delay: 0s; }
        .feature-card:nth-child(2) { transition-delay: 0.1s; }
        .feature-card:nth-child(3) { transition-delay: 0.2s; }
        .feature-card:nth-child(4) { transition-delay: 0.3s; }
        .feature-card:nth-child(5) { transition-delay: 0.4s; }
        .feature-card:nth-child(6) { transition-delay: 0.5s; }
        
        .nav-links.mobile-active {
            display: flex !important;
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            flex-direction: column;
            padding: 20px;
            box-shadow: var(--shadow-lg);
            border-radius: 0 0 8px 8px;
        }
        
        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }
        }
    `;
    document.head.appendChild(style);
    
    // Navbar scroll effect
    let lastScroll = 0;
    window.addEventListener('scroll', function() {
        const navbar = document.querySelector('.navbar');
        const currentScroll = window.pageYOffset;
        
        if (currentScroll > lastScroll && currentScroll > 100) {
            navbar.style.transform = 'translateY(-100%)';
        } else {
            navbar.style.transform = 'translateY(0)';
        }
        
        lastScroll = currentScroll;
    });
    
    // Add navbar transition
    document.querySelector('.navbar').style.transition = 'transform 0.3s ease';
});

// Screenshot slider keyboard navigation
document.addEventListener('keydown', function(e) {
    const slider = document.querySelector('.screenshots-slider');
    if (!slider) return;
    
    if (e.key === 'ArrowLeft') {
        slider.scrollBy({ left: -300, behavior: 'smooth' });
    } else if (e.key === 'ArrowRight') {
        slider.scrollBy({ left: 300, behavior: 'smooth' });
    }
});

// Add touch swipe support for screenshots
let touchStartX = 0;
let touchEndX = 0;

const slider = document.querySelector('.screenshots-slider');
if (slider) {
    slider.addEventListener('touchstart', function(e) {
        touchStartX = e.changedTouches[0].screenX;
    }, false);
    
    slider.addEventListener('touchend', function(e) {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
    }, false);
}

function handleSwipe() {
    const slider = document.querySelector('.screenshots-slider');
    if (touchEndX < touchStartX - 50) {
        slider.scrollBy({ left: 300, behavior: 'smooth' });
    }
    if (touchEndX > touchStartX + 50) {
        slider.scrollBy({ left: -300, behavior: 'smooth' });
    }
}