let currentLanguage = 'en';

function toggleLanguage() {
    currentLanguage = currentLanguage === 'en' ? 'zh' : 'en';
    updateLanguage();
    
    // Update button text
    const langButton = document.querySelector('.lang-switch');
    if (langButton) {
        langButton.textContent = currentLanguage === 'en' ? '中文' : 'English';
    }
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

function toggleMobileMenu() {
    const navLinks = document.querySelector('.nav-links');
    if (navLinks) {
        navLinks.classList.toggle('mobile-active');
    }
}

document.addEventListener('DOMContentLoaded', function() {
    document.querySelector('.lang-switch')?.addEventListener('click', toggleLanguage);
    document.querySelector('.mobile-menu-toggle')?.addEventListener('click', toggleMobileMenu);

    const browserLang = navigator.language || navigator.userLanguage;
    if (browserLang.includes('zh')) {
        toggleLanguage();
    }
    
    const links = document.querySelectorAll('a[href^="#"]');
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                e.preventDefault();
                const navHeight = document.querySelector('.navbar').offsetHeight;
                const targetPosition = targetElement.offsetTop - navHeight - 20;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
    
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
    
    const animatedElements = document.querySelectorAll('.feature-card, .screenshot-item, .download-card');
    animatedElements.forEach(el => {
        observer.observe(el);
    });

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
    
    document.querySelector('.navbar').style.transition = 'transform 0.3s ease';
});

document.addEventListener('keydown', function(e) {
    const slider = document.querySelector('.screenshots-slider');
    if (!slider) return;
    
    if (e.key === 'ArrowLeft') {
        slider.scrollBy({ left: -300, behavior: 'smooth' });
    } else if (e.key === 'ArrowRight') {
        slider.scrollBy({ left: 300, behavior: 'smooth' });
    }
});

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
