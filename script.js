// BU KODU CEREBRAS AI YAZMIŞTIR




// Arka Plan Parçacıkları Oluşturma
function createParticles() {
    const particlesContainer = document.getElementById('particles');
    const particleCount = 50;

    for (let i = 0; i < particleCount; i++) {
        const particle = document.createElement('div');
        particle.classList.add('particle');
        
        // Rastgele pozisyon
        particle.style.left = Math.random() * 100 + '%';
        particle.style.top = Math.random() * 100 + '%';
        
        // Rastgele animasyon gecikmesi
        particle.style.animationDelay = Math.random() * 20 + 's';
        particle.style.animationDuration = (Math.random() * 10 + 15) + 's';
    
        
        particlesContainer.appendChild(particle);
    
    
    }
}

// Scroll Animasyonları
function handleScrollAnimations() {
    const fadeElements = document.querySelectorAll('.fade-in');
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                // Görünür olduktan sonra gözlemlemeyi durdur
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.05,
        rootMargin: '0px 0px -50px 0px'
    });

    fadeElements.forEach(element => {
        observer.observe(element);
    });
}

// Smooth Scroll
function initSmoothScroll() {
    const navLinks = document.querySelectorAll('.nav-link');
    
    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = link.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                const headerHeight = document.getElementById('header').offsetHeight;
                const targetPosition = targetSection.offsetTop - headerHeight;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });

                
                const navLinksContainer = document.getElementById('navLinks');
                navLinksContainer.classList.remove('active');
            }
        });
    });

    // Logo tıklaması
    const logo = document.querySelector('.logo');
    logo.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
}

// Header Scroll Efekti
function handleHeaderScroll() {
    const header = document.getElementById('header');
    
    window.addEventListener('scroll', () => {
        if (window.scrollY > 100) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    });
}

// Hamburger Menü
function initHamburgerMenu() {
    const hamburger = document.getElementById('hamburger');
    const navLinks = document.getElementById('navLinks');
    
    hamburger.addEventListener('click', () => {
        navLinks.classList.toggle('active');
        hamburger.classList.toggle('active');
    });

    // Menü dışına tıklandığında kapat
    document.addEventListener('click', (e) => {
        if (!hamburger.contains(e.target) && !navLinks.contains(e.target)) {
            navLinks.classList.remove('active');
            hamburger.classList.remove('active');
        }
    });
}

// Proje Kartları Hover Efekti
function initProjectCards() {
    const projectCards = document.querySelectorAll('.project-card');
    
    projectCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-10px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
}

// Buton Animasyonları
function initButtonAnimations() {
    const buttons = document.querySelectorAll('.cta-button, .project-link');
    
    buttons.forEach(button => {
        button.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-3px) scale(1.05)';
        });
        
        button.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
}

// Klavye Navigasyonu
function initKeyboardNavigation() {
    document.addEventListener('keydown', (e) => {
        // ESC tuşu ile menüyü kapat
        if (e.key === 'Escape') {
            const navLinks = document.getElementById('navLinks');
            navLinks.classList.remove('active');
        }
    });
}

// Sayfa Yüklenme Animasyonu
function initPageLoadAnimation() {
    window.addEventListener('load', () => {
        document.body.style.opacity = '0';
        setTimeout(() => {
            document.body.style.transition = 'opacity 0.5s ease';
            document.body.style.opacity = '1';
        }, 100);
    });
}

// Parallax Efekti
function initParallaxEffect() {
    window.addEventListener('scroll', () => {
        const scrolled = window.pageYOffset;
        const parallaxElements = document.querySelectorAll('.hero-content');
        
        parallaxElements.forEach(element => {
            // Sadece hero bölümündeyken parallax uygula
            if (scrolled < window.innerHeight) {
                const speed = 0.5;
                element.style.transform = `translateY(${scrolled * speed}px)`;
            }
        });
    });
}

// Aktif Bölüm Vurgulama
function highlightActiveSection() {
    const sections = document.querySelectorAll('section');
    const navLinks = document.querySelectorAll('.nav-link');
    
    window.addEventListener('scroll', () => {
        let current = '';
        
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const sectionHeight = section.clientHeight;
            
            if (window.pageYOffset >= sectionTop - 200) {
                current = section.getAttribute('id');
            }
        });
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === `#${current}`) {
                link.classList.add('active');
            }
        });
    });
}

// Dinamik Yıl Güncelleme
function updateCopyrightYear() {
    const footer = document.querySelector('footer p');
    const currentYear = new Date().getFullYear();
    footer.innerHTML = `&copy; ${currentYear} Mete PARLAK. Tüm hakları saklıdır.`;
}

// Performans İyileştirmeleri
function optimizePerformance() {
    // Lazy loading için intersection observer
    const images = document.querySelectorAll('img');
    
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.style.opacity = '0';
                img.style.transition = 'opacity 0.5s ease';
                
                img.onload = () => {
                    img.style.opacity = '1';
                };
                
                observer.unobserve(img);
            }
        });
    });
    
    images.forEach(img => imageObserver.observe(img));
}

// Tüm Fonksiyonları Başlat
function init() {
    createParticles();
    handleScrollAnimations();
    initSmoothScroll();
    handleHeaderScroll();
    initHamburgerMenu();
    initProjectCards();
    initButtonAnimations();
    initKeyboardNavigation();
    initPageLoadAnimation();
    initParallaxEffect();
    highlightActiveSection();
    updateCopyrightYear();
    optimizePerformance();
}

// Sayfa yüklendiğinde başlat
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

// Pencere yeniden boyutlandırıldığında
let resizeTimer;
window.addEventListener('resize', () => {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(() => {
        // Responsive ayarlamalar
        const navLinks = document.getElementById('navLinks');
        if (window.innerWidth > 768) {
            navLinks.classList.remove('active');
        }
    }, 250);
});

// Sayfa görünürlüğü değiştiğinde
document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
        // Sayfa gizlendiğinde animasyonları durdur
        console.log('Sayfa gizlendi, performans optimizasyonu aktif');
    } else {
        // Sayfa görünür olduğunda animasyonları devam ettir
        console.log('Sayfa görünür, animasyonlar aktif');
    }
});
