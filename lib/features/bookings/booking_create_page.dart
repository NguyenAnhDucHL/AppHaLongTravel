import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';
import 'package:quang_ninh_travel/core/services/booking_service.dart';
import 'package:quang_ninh_travel/core/services/auth_service.dart';
import 'package:intl/intl.dart';

class BookingCreatePage extends StatefulWidget {
  const BookingCreatePage({super.key});

  @override
  State<BookingCreatePage> createState() => _BookingCreatePageState();
}

class _BookingCreatePageState extends State<BookingCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _bookingService = Get.find<BookingService>();
  final _authService = Get.find<AuthService>();

  late Map<String, dynamic> _item;
  late String _itemType;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _guests = 2; // Default
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      Get.back();
      return;
    }
    _item = args['item'];
    _itemType = args['type'];

    // Pre-fill user info if logged in
    final user = _authService.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  double get _totalPrice {
    double basePrice = 0;
    if (_itemType == 'hotel') {
      basePrice = (_item['pricePerNight'] as num?)?.toDouble() ?? 0;
    } else if (_itemType == 'cruise' || _itemType == 'tour') {
      basePrice = (_item['pricePerPerson'] as num?)?.toDouble() ?? 0;
      return basePrice * _guests;
    } else if (_itemType == 'transport') {
       basePrice = (_item['price'] as num?)?.toDouble() ?? 0; // Assuming per trip or per km handled simply
       // For transport, maybe guests doesn't multiply price if it's "per vehicle"
       // But if it's "shuttle", it might. Let's assume per item for now unless logic gets complex.
       // The mock data transport has 'pricePerKm' or 'price'. Let's use a safe fallback.
       basePrice = double.tryParse(_item['price'].toString()) ?? 0;
    }
    return basePrice; // Simplified for MVP
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final bookingData = {
        'itemId': _item['id'],
        'itemType': _itemType,
        'itemName': _item['name'],
        'checkIn': _selectedDate.toIso8601String(),
        'guests': _guests,
        'totalPrice': _totalPrice,
        'currency': 'USD', // Default for now
        'guestInfo': {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        },
        'notes': _notesController.text,
      };

      await _bookingService.createBooking(bookingData);

      if (mounted) {
        Get.back();
        Get.snackbar(
          'success'.tr,
          'booking_confirmed_sub'.tr,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('error'.tr, e.toString(), backgroundColor: AppColors.error, colorText: Colors.white);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('booking_title'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Summary
              _buildItemSummary(),
              const SizedBox(height: AppTheme.spacingL),

              // Trip Details
              Text('trip_details'.tr, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppTheme.spacingM),
              
              _buildDateSelector(),
              const SizedBox(height: AppTheme.spacingM),
              
              _buildGuestSelector(),
              const SizedBox(height: AppTheme.spacingL),

              // Contact Details
              Text('contact_details'.tr, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppTheme.spacingM),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'full_name'.tr,
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'fill_all_fields'.tr : null,
              ),
              const SizedBox(height: AppTheme.spacingM),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'fill_all_fields'.tr : null,
              ),
              const SizedBox(height: AppTheme.spacingM),

              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'phone'.tr,
                  prefixIcon: const Icon(Icons.phone),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'fill_all_fields'.tr : null,
              ),
              const SizedBox(height: AppTheme.spacingM),

              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'special_requests'.tr,
                  hintText: 'notes_hint'.tr,
                  prefixIcon: const Icon(Icons.note),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: AppTheme.spacingXL),

              // Total & Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('total'.tr, style: Theme.of(context).textTheme.bodyMedium),
                      Text(
                        '\$${_totalPrice.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitBooking,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('confirm'.tr), // Or 'confirm_booking'.tr
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemSummary() {
    final images = _item['images'] as List?;
    final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
            child: Container(
              width: 80,
              height: 80,
              color: AppColors.primaryLight.withOpacity(0.3),
              child: imageUrl != null
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : const Icon(Icons.image, color: AppColors.textLight),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _item['name'] ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _itemType.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: _itemType == 'hotel' ? 'check_in_date'.tr : 'date'.tr,
          prefixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        child: Text(
          DateFormat('EEE, d MMM yyyy').format(_selectedDate),
        ),
      ),
    );
  }

  Widget _buildGuestSelector() {
    return Row(
      children: [
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'guests'.tr,
              prefixIcon: const Icon(Icons.people),
              border: const OutlineInputBorder(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$_guests'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _guests++),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
