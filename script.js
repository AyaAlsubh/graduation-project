document.querySelector('.next').addEventListener('click', () => {
    document.querySelector('.cards-wrapper').scrollBy({ left: 220, behavior: 'smooth' });
});

document.querySelector('.prev').addEventListener('click', () => {
    document.querySelector('.cards-wrapper').scrollBy({ left: -220, behavior: 'smooth' });
});

// 1. قاعدة بيانات تجريبية (لازم البيانات هون تشبه اللي بالـ HTML عشان الفحص الأولي)
const photographers = [
    { name: "Ahmad Ali", location: "اربد", date: "2026-05-10", price: 30, type: "مصور", rating: 4.8, img: "https://via.placeholder.com/200x150" },
    { name: "Samer Jaber", location: "عمان", date: "2026-05-12", price: 50, type: "مصور", rating: 5, img: "https://via.placeholder.com/200x150" },
    { name: "Eman Samer", location: "اربد", date: "2026-05-15", price: 20, type: "استوديو", rating: 4.5, img: "https://via.placeholder.com/200x150" },
    { name: "Reem Photo", location: "الزرقاء", date: "2026-05-20", price: 90, type: "استوديو", rating: 3, img: "https://via.placeholder.com/200x150" }
];

// 2. ربط عناصر الـ HTML
const nameInput = document.querySelector('input[placeholder="اسم المصور"]');
const locationInput = document.querySelector('.highlight-input');
const dateInput = document.querySelector('input[type="date"]');
const priceInput = document.querySelector('input[type="range"]');
const priceDisplay = document.querySelector('.price-val');
const toggleButtons = document.querySelectorAll('.toggle-buttons button');
const ratingTags = document.querySelectorAll('.rate-tag');
const filterBtn = document.querySelector('.btn-orange-full');
const resultsGrid = document.querySelector('.results-grid');

// متغيرات لتخزين القيم المختارة (النوع والتقييم)
let selectedType = "مصور"; 
let selectedRating = null;

// 3. تحديث رقم السعر عند تحريك الشريط
priceInput.addEventListener('input', () => {
    priceDisplay.textContent = priceInput.value;
});

// 4. اختيار النوع (مصور / استوديو)
toggleButtons.forEach(btn => {
    btn.addEventListener('click', () => {
        toggleButtons.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        selectedType = btn.textContent.trim(); // يأخذ النص "مصور" أو "استوديو"
    });
});

// 5. اختيار التقييم
ratingTags.forEach(tag => {
    tag.addEventListener('click', () => {
        ratingTags.forEach(t => t.classList.remove('active'));
        tag.classList.add('active');
        // استخراج الرقم من النص "⭐ 4.8" ليصبح 4.8
        selectedRating = parseFloat(tag.textContent.replace('⭐', '').trim());
    });
});

// 6. منطق الفلترة عند الضغط على الزر
filterBtn.addEventListener('click', () => {
    const nameVal = nameInput.value.toLowerCase().trim();
    const locationVal = locationInput.value.trim();
    const dateVal = dateInput.value;
    const maxPrice = parseInt(priceInput.value);

    const filtered = photographers.filter(p => {
        const matchesName = p.name.toLowerCase().includes(nameVal);
        const matchesLocation = locationVal === "" || p.location.includes(locationVal);
        const matchesDate = dateVal === "" || p.date === dateVal;
        const matchesPrice = p.price <= maxPrice;
        const matchesType = p.type === selectedType;
        const matchesRating = selectedRating === null || p.rating === selectedRating;

        return matchesName && matchesLocation && matchesDate && matchesPrice && matchesType && matchesRating;
    });

    renderResults(filtered);
});

// 7. وظيفة طباعة الكروت في الصفحة
function renderResults(list) {
    resultsGrid.innerHTML = ""; // مسح النتائج القديمة
    
    if (list.length === 0) {
        resultsGrid.innerHTML = `<p style="grid-column: 1/-1; text-align: center; padding: 20px;">لا يوجد مصورين يطابقون هذه الاختيارات.</p>`;
        return;
    }

    list.forEach(p => {
        resultsGrid.innerHTML += `
            <div class="card">
                <div class="img-wrapper">
                    <img src="${p.img}" alt="${p.name}">
                </div>
                <h3>${p.name}</h3>
                <p class="rating">⭐ ${p.rating}</p>
                <p class="location">📍 ${p.location}, Jordan</p>
                <a href="profile.html" class="btn-detail">التفاصيل</a>
            </div>
        `;
    });
}

// تشغيل العرض الأول عند تحميل الصفحة
renderResults(photographers);