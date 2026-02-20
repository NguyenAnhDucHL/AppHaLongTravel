import * as admin from 'firebase-admin';

// Initialize with service account for local seeding
// Run: npx ts-node src/seed/seed-data.ts
if (!admin.apps.length) {
    admin.initializeApp();
}
const db = admin.firestore();

const hotels = [
    {
        name: 'Paradise Suites Hotel',
        description: 'Khách sạn 5 sao tọa lạc trên đảo Tuần Châu, nhìn ra vịnh Hạ Long.',
        location: 'Tuần Châu, Hạ Long',
        address: 'Đảo Tuần Châu, TP Hạ Long, Quảng Ninh',
        lat: 20.9467, lng: 106.9686,
        rating: 4.8, reviewCount: 245,
        pricePerNight: 2500000, currency: 'VND',
        amenities: ['WiFi', 'Hồ bơi', 'Spa', 'Nhà hàng', 'Phòng gym', 'Bãi biển riêng'],
        images: [], category: 'luxury', featured: true,
        rooms: [
            { type: 'Deluxe', price: 2500000, capacity: 2, available: 10, description: 'Phòng Deluxe view biển' },
            { type: 'Suite', price: 4500000, capacity: 2, available: 5, description: 'Suite hướng vịnh' },
            { type: 'Family', price: 3500000, capacity: 4, available: 8, description: 'Phòng gia đình' },
        ],
        contactInfo: { phone: '0203-3842-999', email: 'info@paradise.com', website: 'https://paradise.com' },
    },
    {
        name: 'Novotel Ha Long Bay',
        description: 'Khách sạn quốc tế tiêu chuẩn 5 sao tại Bãi Cháy.',
        location: 'Bãi Cháy, Hạ Long',
        address: '160 Hạ Long, Bãi Cháy, TP Hạ Long',
        lat: 20.9551, lng: 107.0495,
        rating: 4.6, reviewCount: 189,
        pricePerNight: 1800000, currency: 'VND',
        amenities: ['WiFi', 'Hồ bơi', 'Nhà hàng', 'Bar', 'Phòng gym'],
        images: [], category: 'luxury', featured: true,
        rooms: [
            { type: 'Superior', price: 1800000, capacity: 2, available: 15, description: 'Superior view thành phố' },
            { type: 'Deluxe', price: 2200000, capacity: 2, available: 10, description: 'Deluxe view biển' },
        ],
        contactInfo: { phone: '0203-3848-108', email: 'booking@novotelhalong.com', website: 'https://novotelhalong.com' },
    },
    {
        name: 'Wyndham Legend Halong',
        description: 'Khu nghỉ dưỡng sang trọng bên bờ vịnh Hạ Long.',
        location: 'Bãi Cháy, Hạ Long',
        address: '12 Hạ Long, Bãi Cháy, TP Hạ Long',
        lat: 20.9525, lng: 107.0532,
        rating: 4.7, reviewCount: 320,
        pricePerNight: 3200000, currency: 'VND',
        amenities: ['WiFi', 'Hồ bơi vô cực', 'Spa', 'Nhà hàng', 'Casino'],
        images: [], category: 'luxury', featured: true,
        rooms: [
            { type: 'Deluxe', price: 3200000, capacity: 2, available: 12, description: 'Deluxe hướng biển' },
            { type: 'Presidential Suite', price: 8000000, capacity: 2, available: 2, description: 'Suite tổng thống' },
        ],
        contactInfo: { phone: '0203-3636-555', email: 'info@wyndhamhalong.com', website: 'https://wyndhamhalong.com' },
    },
    {
        name: 'FLC Grand Hotel Ha Long',
        description: 'Khách sạn lớn với tầm nhìn toàn cảnh vịnh Hạ Long.',
        location: 'Bãi Cháy, Hạ Long',
        address: 'Phường Hùng Thắng, TP Hạ Long',
        lat: 20.9498, lng: 107.0620,
        rating: 4.4, reviewCount: 156,
        pricePerNight: 1500000, currency: 'VND',
        amenities: ['WiFi', 'Hồ bơi', 'Nhà hàng', 'Sân golf'],
        images: [], category: 'resort', featured: false,
        rooms: [
            { type: 'Standard', price: 1500000, capacity: 2, available: 20, description: 'Phòng tiêu chuẩn' },
            { type: 'Deluxe', price: 2000000, capacity: 2, available: 15, description: 'Phòng cao cấp' },
        ],
        contactInfo: { phone: '0203-3556-888', email: 'res@flchalong.com' },
    },
    {
        name: 'Mường Thanh Luxury Quảng Ninh',
        description: 'Chuỗi khách sạn Mường Thanh tại trung tâm TP Hạ Long.',
        location: 'Trung tâm Hạ Long',
        address: 'Đường Trần Quốc Nghiễn, TP Hạ Long',
        lat: 20.9530, lng: 107.0650,
        rating: 4.3, reviewCount: 210,
        pricePerNight: 1200000, currency: 'VND',
        amenities: ['WiFi', 'Nhà hàng', 'Phòng gym', 'Spa'],
        images: [], category: 'business', featured: false,
        rooms: [
            { type: 'Standard', price: 1200000, capacity: 2, available: 25, description: 'Phòng tiêu chuẩn' },
            { type: 'VIP', price: 2500000, capacity: 2, available: 5, description: 'Phòng VIP' },
        ],
        contactInfo: { phone: '0203-3812-345', email: 'info@muongthanh.com' },
    },
];

const cruises = [
    {
        name: 'Ambassador Cruise',
        description: 'Du thuyền 5 sao sang trọng nhất vịnh Hạ Long với 46 cabin.',
        duration: '2 ngày 1 đêm', route: 'Hạ Long Bay - Bái Tử Long',
        rating: 4.9, reviewCount: 380, pricePerPerson: 4500000,
        highlights: ['Hang Sửng Sốt', 'Đảo Ti Tốp', 'Chèo Kayak', 'Nấu ăn trên tàu'],
        itinerary: [
            { time: '08:00', title: 'Check-in tại cảng', description: 'Đón khách tại cảng tàu Hạ Long' },
            { time: '12:00', title: 'Buffet trưa', description: 'Thưởng thức hải sản trên vịnh' },
            { time: '15:00', title: 'Hang Sửng Sốt', description: 'Tham quan hang động đẹp nhất' },
            { time: '17:00', title: 'Chèo Kayak', description: 'Chèo kayak quanh làng chài' },
        ],
        cabinTypes: [
            { name: 'Deluxe', price: 4500000, capacity: 2, description: 'Cabin 25m²', amenities: ['Ban công', 'Bồn tắm'] },
            { name: 'Suite', price: 7000000, capacity: 2, description: 'Suite 40m²', amenities: ['Jacuzzi', 'Phòng khách riêng'] },
        ],
        images: [], included: ['Bữa ăn', 'Kayak', 'Hướng dẫn viên', 'Vé tham quan'],
        excluded: ['Đồ uống', 'Tip', 'Spa'],
        contactInfo: { phone: '0901-234-567', email: 'sales@ambassadorcruise.com', website: 'https://ambassadorcruise.com' },
    },
    {
        name: 'Paradise Elegance',
        description: 'Du thuyền boutique cao cấp với phong cách Đông Dương.',
        duration: '2 ngày 1 đêm', route: 'Hạ Long Bay',
        rating: 4.7, reviewCount: 256, pricePerPerson: 3800000,
        highlights: ['Hang Luồn', 'Kayak', 'Tai Chi buổi sáng', 'BBQ trên boong'],
        itinerary: [
            { time: '09:00', title: 'Khởi hành', description: 'Rời cảng Tuần Châu' },
            { time: '12:30', title: 'Ăn trưa', description: 'Set menu Việt Nam' },
            { time: '14:00', title: 'Hang Luồn', description: 'Khám phá hang động bằng thuyền nan' },
        ],
        cabinTypes: [
            { name: 'Premium', price: 3800000, capacity: 2, description: 'Cabin Premium 22m²', amenities: ['View biển', 'Minibar'] },
        ],
        images: [], included: ['Bữa ăn', 'Kayak', 'Vé hang'], excluded: ['Đồ uống', 'Tip'],
    },
    {
        name: 'Stellar of the Seas',
        description: 'Du thuyền hiện đại nhất vịnh Hạ Long với hồ bơi trên tàu.',
        duration: '3 ngày 2 đêm', route: 'Hạ Long - Lan Hạ Bay',
        rating: 4.8, reviewCount: 198, pricePerPerson: 6500000,
        highlights: ['Hồ bơi trên tàu', 'Đảo Cát Bà', 'Làng chài Việt Hải', 'Lặn biển'],
        itinerary: [
            { time: '08:30', title: 'Check-in', description: 'Cảng Tuần Châu' },
            { time: '13:00', title: 'Ăn trưa & cruise', description: 'Ngắm cảnh vịnh' },
            { time: '16:00', title: 'Đảo Cát Bà', description: 'Trekking trên đảo' },
        ],
        cabinTypes: [
            { name: 'Deluxe', price: 6500000, capacity: 2, description: 'Cabin 28m²', amenities: ['Ban công', 'Bồn tắm'] },
            { name: 'Executive', price: 9000000, capacity: 2, description: 'Suite 45m²', amenities: ['Jacuzzi riêng', 'Butler'] },
        ],
        images: [], included: ['Bữa ăn', 'Kayak', 'Xe đưa đón', 'Hồ bơi'],
        excluded: ['Đồ uống cao cấp', 'Spa', 'Tip'],
        contactInfo: { phone: '0912-345-678', email: 'info@stellaroftheseas.com', website: 'https://stellaroftheseas.com' },
    },
];

const tours = [
    {
        name: 'Vịnh Hạ Long Full Day',
        description: 'Tham quan toàn cảnh vịnh Hạ Long trong một ngày.',
        duration: '8 tiếng', difficulty: 'easy',
        rating: 4.6, reviewCount: 450, pricePerPerson: 800000, groupSize: 20,
        schedule: [
            { day: 1, title: 'Khởi hành từ Bãi Cháy', description: 'Đón khách tại khách sạn' },
            { day: 1, title: 'Hang Sửng Sốt', description: 'Tham quan hang động' },
            { day: 1, title: 'Đảo Ti Tốp', description: 'Tắm biển và leo núi' },
        ],
        guide: { name: 'Nguyễn Văn Hùng', avatar: '', experience: '10 năm', languages: ['vi', 'en', 'zh'] },
        images: [],
        contactInfo: { phone: '0987-654-321', email: 'tours@halongtravel.com' },
    },
    {
        name: 'Bái Tử Long Kayaking',
        description: 'Chèo kayak khám phá vùng vịnh hoang sơ Bái Tử Long.',
        duration: '6 tiếng', difficulty: 'moderate',
        rating: 4.8, reviewCount: 178, pricePerPerson: 1200000, groupSize: 10,
        schedule: [
            { day: 1, title: 'Cảng Vân Đồn', description: 'Xuất phát' },
            { day: 1, title: 'Chèo Kayak', description: '3 tiếng qua các hang và vịnh nhỏ' },
            { day: 1, title: 'Picnic trên đảo', description: 'Ăn trưa trên đảo hoang' },
        ],
        guide: { name: 'Trần Minh Đức', avatar: '', experience: '7 năm', languages: ['vi', 'en'] },
        images: [],
    },
    {
        name: 'Yên Tử Mountain Trek',
        description: 'Leo núi Yên Tử - Đất Phật thiêng liêng.',
        duration: '1 ngày', difficulty: 'hard',
        rating: 4.5, reviewCount: 312, pricePerPerson: 600000, groupSize: 15,
        schedule: [
            { day: 1, title: 'Chân núi Yên Tử', description: 'Bắt đầu hành trình' },
            { day: 1, title: 'Chùa Đồng', description: 'Chinh phục đỉnh Yên Tử 1068m' },
        ],
        guide: { name: 'Lê Thị Mai', avatar: '', experience: '5 năm', languages: ['vi', 'en'] },
        images: [],
    },
    {
        name: 'Đảo Cô Tô Adventure',
        description: 'Khám phá đảo Cô Tô hoang sơ trong 2 ngày.',
        duration: '2 ngày 1 đêm', difficulty: 'moderate',
        rating: 4.7, reviewCount: 145, pricePerPerson: 2500000, groupSize: 12,
        schedule: [
            { day: 1, title: 'Cảng Cái Rồng', description: 'Đi tàu cao tốc ra đảo' },
            { day: 1, title: 'Bãi biển Hồng Vàn', description: 'Tắm biển hoang sơ' },
            { day: 2, title: 'Ngọn hải đăng', description: 'Ngắm bình minh từ hải đăng Cô Tô' },
        ],
        guide: { name: 'Phạm Văn Tú', avatar: '', experience: '8 năm', languages: ['vi'] },
        images: [],
    },
];

const restaurants = [
    {
        name: 'Nhà Hàng Phương Nam',
        description: 'Nhà hàng hải sản nổi tiếng nhất Bãi Cháy.',
        cuisine: ['Hải sản', 'Việt Nam'], address: 'Đường Hạ Long, Bãi Cháy',
        lat: 20.9560, lng: 107.0480,
        rating: 4.5, reviewCount: 520, priceRange: '$$',
        popularDishes: ['Tôm hùm nướng', 'Sò điệp', 'Mực nướng sa tế'],
        menu: [
            { name: 'Tôm hùm nướng', price: 850000, description: 'Tôm hùm Alaska nướng bơ tỏi', category: 'Hải sản', popular: true },
            { name: 'Sò điệp nướng mỡ hành', price: 180000, description: 'Sò điệp tươi nướng', category: 'Hải sản', popular: true },
            { name: 'Cơm chiên hải sản', price: 120000, description: 'Cơm rang với hải sản tổng hợp', category: 'Cơm', popular: false },
        ],
        contactInfo: { phone: '0203-3846-789', email: 'info@phuongnam.vn' },
        images: [], openingHours: '10:00 - 22:00',
    },
    {
        name: 'Quán Ăn Làng Chài',
        description: 'Quán ăn bình dân view đẹp tại cảng cá Cái Dăm.',
        cuisine: ['Hải sản', 'Bình dân'], address: 'Cảng cá Cái Dăm, Bãi Cháy',
        lat: 20.9545, lng: 107.0525,
        rating: 4.3, reviewCount: 350, priceRange: '$',
        popularDishes: ['Chả mực Hạ Long', 'Bún hải sản', 'Sam biển'],
        menu: [
            { name: 'Chả mực Hạ Long', price: 150000, description: 'Đặc sản nổi tiếng', category: 'Đặc sản', popular: true },
            { name: 'Bún hải sản', price: 60000, description: 'Bún với hải sản tươi', category: 'Bún/Phở', popular: true },
        ],
        contactInfo: { phone: '0203-3847-123' },
        images: [], openingHours: '06:00 - 21:00',
    },
    {
        name: 'Cái Dăm Seafood Market',
        description: 'Chợ hải sản tươi sống, chế biến tại chỗ.',
        cuisine: ['Hải sản', 'Chợ'], address: 'Chợ Cái Dăm, Bãi Cháy',
        lat: 20.9540, lng: 107.0510,
        rating: 4.1, reviewCount: 280, priceRange: '$',
        popularDishes: ['Ghẹ hấp', 'Ốc', 'Tôm sú'],
        menu: [
            { name: 'Ghẹ hấp bia', price: 200000, description: 'Ghẹ tươi hấp bia', category: 'Hải sản', popular: true },
            { name: 'Ốc hương xào bơ', price: 250000, description: 'Ốc hương Vân Đồn', category: 'Hải sản', popular: true },
        ],
        contactInfo: { phone: '0203-3845-456' },
        images: [], openingHours: '05:00 - 20:00',
    },
];

const transport = [
    {
        name: 'Xe buýt sân bay',
        type: 'Bus',
        capacity: 16,
        price: 150000,
        currency: 'VND',
        available: true,
        status: 'active',
        rating: 4.5,
        images: [],
        description: 'Xe shuttle sân bay Vân Đồn - Hạ Long, đón trả tận nơi.',
        contactInfo: { phone: '0203-3842-123' }
    },
    {
        name: 'Xe riêng 4 chỗ Vios',
        type: 'Private Car',
        capacity: 4,
        price: 12000, // Per km? Frontend uses fixed price input, but model implies fixed or rate. Let's use fixed base or rate. 
        // Frontend "Price" usually implies per unit. For transport it's ambiguous. Let's assume standard booking price or base price.
        currency: 'VND',
        available: true,
        status: 'active',
        rating: 4.8,
        images: [],
        description: 'Xe riêng 4 chỗ đời mới, tài xế thân thiện.',
        contactInfo: { phone: '0905-123-456' }
    },
    {
        name: 'Xe Limousine 9 chỗ',
        type: 'Limousine',
        capacity: 9,
        price: 250000,
        currency: 'VND',
        available: true,
        status: 'active',
        rating: 4.9,
        images: [],
        description: 'Xe Limousine sang trọng, ghế massage.',
        contactInfo: { phone: '0987-123-123' }
    },
    {
        name: 'Thuê xe máy tay ga',
        type: 'Motorbike',
        capacity: 2,
        price: 150000,
        currency: 'VND',
        available: true,
        status: 'active',
        rating: 4.2,
        images: [],
        description: 'Xe máy tay ga các loại (Airblade, Vision).',
        contactInfo: { phone: '0912-345-678' }
    },
    {
        name: 'Tàu cao tốc Cô Tô',
        type: 'Boat',
        capacity: 50,
        price: 250000,
        currency: 'VND',
        available: true,
        status: 'active',
        rating: 4.7,
        images: [],
        description: 'Tàu cao tốc đi đảo Cô Tô, xuất phát cảng Cái Rồng.',
        contactInfo: { phone: '0945-678-901' }
    },
];

export async function seedDatabase(db: admin.firestore.Firestore) {
    console.log('🌱 Seeding Quang Ninh Travel database...');

    const collections = [
        { name: 'hotels', data: hotels },
        { name: 'cruises', data: cruises },
        { name: 'tours', data: tours },
        { name: 'restaurants', data: restaurants },
        { name: 'transport', data: transport },
    ];

    const results: any[] = [];

    for (const { name, data } of collections) {
        // Check if collection is empty to avoid duplicates
        const snapshot = await db.collection(name).limit(1).get();
        if (!snapshot.empty) {
            console.log(`⚠ Collection ${name} is not empty, skipping...`);
            results.push({ collection: name, status: 'skipped', reason: 'not empty' });
            continue;
        }

        console.log(`📦 Seeding ${name}...`);
        const batch = db.batch();
        for (const item of data) {
            const ref = db.collection(name).doc();
            batch.set(ref, { ...item, createdAt: admin.firestore.Timestamp.now() });
        }
        await batch.commit();
        console.log(`   ✓ ${data.length} ${name} added`);
        results.push({ collection: name, status: 'seeded', count: data.length });
    }

    console.log('\n✅ Seed complete!');
    return results;
}
