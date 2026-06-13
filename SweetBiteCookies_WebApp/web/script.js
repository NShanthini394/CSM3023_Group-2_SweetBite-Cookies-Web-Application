/* ==========================================
   SWEETBITE COOKIES - MAIN SCRIPT
   ========================================== */

/* 1. Main Page Slideshow */
let slideIndex = 0;
showSlides();

function showSlides() {
    let i;
    let slides = document.getElementsByClassName("slides");
    let dots = document.getElementsByClassName("dot");

    for (i = 0; i < slides.length; i++) {
        slides[i].style.display = "none";
    }

    slideIndex++;
    if (slideIndex > slides.length) {
        slideIndex = 1;
    }

    for (i = 0; i < dots.length; i++) {
        dots[i].className = dots[i].className.replace(" active", "");
    }

    slides[slideIndex - 1].style.display = "block";
    dots[slideIndex - 1].className += " active";

    setTimeout(showSlides, 3000); // Change image every 3 seconds
}

/* 2. Scroll to Top Button Logic */
let topBtn = document.getElementById("topBtn");

window.onscroll = function () {
    if (document.documentElement.scrollTop > 300) {
        topBtn.style.display = "block";
    } else {
        topBtn.style.display = "none";
    }
};

function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: "smooth"
    });
}

/* 3. Mobile Navbar Toggle */
function toggleMenu() {
    document.getElementById("navLinks").classList.toggle("active");
}

// Auto-close mobile menu when a link is clicked
document.querySelectorAll(".nav-links a").forEach(link => {
    link.addEventListener("click", () => {
        document.getElementById("navLinks").classList.remove("active");
    });
});