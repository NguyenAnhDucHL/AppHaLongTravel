# Ha Long Travel App

A professional tourism booking application for Ha Long Bay built with Flutter.

## 🌟 Features

- **Multi-Service Booking**: Hotels, Cruises, Transport, Restaurants, and Tour Packages
- **Modern UI/UX**: Material 3 design with ocean-inspired color palette
- **Cross-Platform**: Runs on iOS, Android, Web, macOS, Windows, and Linux
- **Clean Architecture**: Feature-based modular structure
- **State Management**: GetX for efficient state management and routing

## 🎨 Screenshots

[Add screenshots here]

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.7.2)
- Dart SDK
- IDE (VS Code, Android Studio, or IntelliJ IDEA)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/NguyenAnhDucHL/AppHaLongTravel.git
cd AppHaLongTravel
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# On Chrome (Web)
flutter run -d chrome

# On Android
flutter run -d android

# On iOS
flutter run -d ios

# On macOS
flutter run -d macos
```

## 📱 Main Features

### Home Screen
- Auto-playing hero carousel with Ha Long Bay imagery
- Service category grid (6 categories)
- Featured deals and promotions
- Popular destinations
- Bottom navigation bar

### Hotels & Resorts
- Hotel listings with filters
- Ratings and reviews
- Per-night pricing
- Location information

### Cruise Tours
- Luxury and standard cruise options
- Trip duration (1-day, overnight)
- Itinerary preview
- Booking availability

### Transport Services
- Airport transfers
- Private car rentals
- Car with driver services
- 24/7 availability

### Restaurants
- Cuisine filter (Vietnamese, Seafood, Chinese, Western)
- Distance from location
- Ratings and reviews
- Reservation capability

### Tour Packages
- Pre-designed tour packages
- Duration and group size info
- Per-person pricing
- Best seller badges

### Profile & Settings
- User profile management
- Booking history
- Favorites/wishlist
- Language settings
- Payment methods

## 🏗️ Project Structure

```
lib/
├── app/
│   ├── routes/          # Navigation routing
│   └── themes/          # App theme & colors
├── core/
│   ├── constants/       # Constants
│   ├── utils/           # Utilities
│   └── widgets/         # Core widgets
├── features/            # Feature modules
│   ├── home/
│   ├── hotels/
│   ├── cruises/
│   ├── transport/
│   ├── restaurants/
│   ├── tours/
│   └── profile/
└── shared/
    ├── models/          # Data models
    ├── services/        # Business logic
    └── widgets/         # Shared widgets
```

## 📦 Dependencies

- **GetX** - State management & routing
- **Google Fonts** - Typography (Poppins & Inter)
- **Carousel Slider** - Image carousels
- **Google Maps Flutter** - Maps integration
- **Cached Network Image** - Image caching
- **Flutter Rating Bar** - Star ratings
- **Dio** - HTTP client
- **Shared Preferences** - Local storage

## 🎨 Theme

The app uses an ocean-inspired color palette:
- **Primary Blue**: `#0077BE` (Deep ocean)
- **Accent Orange**: `#FF6B35` (Sunset)
- **Light Blue**: `#4FC3F7` (Sky)
- **Gold**: `#FFB300` (Golden hour)

## 🔧 Configuration

The app is configured to work with:
- Organization: `com.halongtravel`
- Package name: `ha_long_travel`
- Supported platforms: iOS, Android, Web, macOS, Windows, Linux

## 📄 License

This project is private and proprietary.

## 👨‍💻 Author

**Nguyen Anh Duc**
- GitHub: [@NguyenAnhDucHL](https://github.com/NguyenAnhDucHL)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Ha Long Bay tourism board for inspiration
- Unsplash for beautiful Ha Long Bay images

## 📞 Contact

For questions or support, please contact: [Your Email]

---

Made with ❤️ for Ha Long Bay Tourism
