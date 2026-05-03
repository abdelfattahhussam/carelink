import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Mock interceptor that simulates backend API responses.
/// Remove this interceptor and point to real base URL for production.
class MockInterceptor extends Interceptor {
  // In-memory mock data stores (instance-level for test isolation)
  final List<Map<String, dynamic>> _users;
  final List<Map<String, dynamic>> _pharmacies;
  final List<Map<String, dynamic>> _medicines;
  final List<Map<String, dynamic>> _donations;
  final List<Map<String, dynamic>> _requests;
  final List<Map<String, dynamic>> _notifications;
  final Set<String> _dismissedExpiryIds;

  final _uuid = const Uuid();

  /// Default constructor with fresh seed data.
  MockInterceptor()
      : _users = _buildDefaultUsers(),
        _pharmacies = _buildDefaultPharmacies(),
        _medicines = _buildDefaultMedicines(),
        _donations = _buildDefaultDonations(),
        _requests = _buildDefaultRequests(),
        _notifications = _buildDefaultNotifications(),
        _dismissedExpiryIds = {};

  /// Test constructor for injecting custom seed state.
  @visibleForTesting
  MockInterceptor.withState({
    List<Map<String, dynamic>>? users,
    List<Map<String, dynamic>>? pharmacies,
    List<Map<String, dynamic>>? medicines,
    List<Map<String, dynamic>>? donations,
    List<Map<String, dynamic>>? requests,
    List<Map<String, dynamic>>? notifications,
  })  : _users = users ?? _buildDefaultUsers(),
        _pharmacies = pharmacies ?? _buildDefaultPharmacies(),
        _medicines = medicines ?? _buildDefaultMedicines(),
        _donations = donations ?? _buildDefaultDonations(),
        _requests = requests ?? _buildDefaultRequests(),
        _notifications = notifications ?? _buildDefaultNotifications(),
        _dismissedExpiryIds = {};

  // ─── DEFAULT SEED DATA BUILDERS ───

  static List<Map<String, dynamic>> _buildDefaultUsers() => [
    {
      'id': 'user-1',
      'name': 'Ahmed Hassan',
      'email': 'user@test.com',
      'phone': '+201234567890',
      'nationalId': '29001011234567',
      'role': 'user',
      'password': 'password123',
      'status': 'verified',
      'token': 'mock-jwt-token-donor',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 30))
          .toIso8601String(),
    },
    {
      'id': 'user-2',
      'name': 'Sara Mohamed',
      'email': 'user2@test.com',
      'phone': '+201098765432',
      'nationalId': '29505057654321',
      'role': 'user',
      'password': 'password123',
      'status': 'verified',
      'token': 'mock-jwt-token-patient',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 20))
          .toIso8601String(),
    },
    {
      'id': 'user-3',
      'name': 'Dr. Khaled Ali',
      'email': 'pharmacist@test.com',
      'phone': '+201112233445',
      'nationalId': '28004041122334',
      'role': 'pharmacist',
      'password': 'password123',
      'status': 'verified',
      'token': 'mock-jwt-token-pharmacist',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 60))
          .toIso8601String(),
    },
  ];

  static List<Map<String, dynamic>> _buildDefaultPharmacies() => [
    {
      'id': 'pharm-1',
      'name': 'صيدلية النور',
      'pharmacistId': 'user-3',
      'governorate': 'القاهرة',
      'city': 'مدينة نصر',
      'district': 'الحي الثامن',
      'address': 'شارع عباس العقاد',
      'isActive': true,
    },
    {
      'id': 'pharm-2',
      'name': 'صيدلية الشفاء',
      'pharmacistId': 'user-4',
      'governorate': 'القاهرة',
      'city': 'المعادي',
      'district': 'المعادي الجديدة',
      'address': 'شارع الكورنيش',
      'isActive': true,
    },
    {
      'id': 'pharm-3',
      'name': 'صيدلية الأمل',
      'pharmacistId': 'user-5',
      'governorate': 'الإسكندرية',
      'city': 'سيدي بشر',
      'district': 'سيدي بشر قبلي',
      'address': 'شارع الملك فيصل',
      'isActive': true,
    },
    {
      'id': 'pharm-4',
      'name': 'صيدلية الحياة',
      'pharmacistId': 'user-6',
      'governorate': 'الجيزة',
      'city': 'الدقي',
      'district': 'وسط الدقي',
      'address': 'شارع التحرير',
      'isActive': true,
    },
    {
      'id': 'pharm-5',
      'name': 'صيدلية الرعاية',
      'pharmacistId': 'user-7',
      'governorate': 'القاهرة',
      'city': 'مدينة نصر',
      'district': 'الحي العاشر',
      'address': 'شارع مكرم عبيد',
      'isActive': true,
    },
  ];

  static List<Map<String, dynamic>> _buildDefaultMedicines() => [
    {
      'id': 'med-1',
      'name': 'Amoxicillin 500mg',
      'description': 'Antibiotic capsules for bacterial infections',
      'expiryDate': DateTime.now()
          .add(const Duration(days: 180))
          .toIso8601String(),
      'quantity': 24,
      'unit': 'strip',
      'donorId': 'user-1',
      'donorName': 'Ahmed Hassan',
      'status': 'approved',
      'imageUrl': '',
      'category': 'Antibiotics',
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 5))
          .toIso8601String(),
    },
    {
      'id': 'med-2',
      'name': 'Paracetamol 500mg',
      'description': 'Pain reliever and fever reducer tablets',
      'expiryDate': DateTime.now()
          .add(const Duration(days: 365))
          .toIso8601String(),
      'quantity': 50,
      'unit': 'box',
      'donorId': 'user-1',
      'donorName': 'Ahmed Hassan',
      'status': 'approved',
      'imageUrl': '',
      'category': 'Pain Relief',
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 3))
          .toIso8601String(),
    },
    {
      'id': 'med-3',
      'name': 'Omeprazole 20mg',
      'description': 'Proton pump inhibitor for acid reflux',
      'expiryDate': DateTime.now()
          .add(const Duration(days: 90))
          .toIso8601String(),
      'quantity': 14,
      'unit': 'strip',
      'donorId': 'user-1',
      'donorName': 'Ahmed Hassan',
      'status': 'approved',
      'imageUrl': '',
      'category': 'Digestive',
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 2))
          .toIso8601String(),
    },
    {
      'id': 'med-4',
      'name': 'Metformin 850mg',
      'description': 'Oral diabetes medicine to control blood sugar',
      'expiryDate': DateTime.now()
          .add(const Duration(days: 240))
          .toIso8601String(),
      'quantity': 30,
      'unit': 'box',
      'donorId': 'user-1',
      'donorName': 'Ahmed Hassan',
      'status': 'pending',
      'imageUrl': '',
      'category': 'Diabetes',
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
    },
    {
      'id': 'med-5',
      'name': 'Losartan 50mg',
      'description': 'Angiotensin receptor blocker for hypertension',
      'expiryDate': DateTime.now()
          .subtract(const Duration(days: 10))
          .toIso8601String(),
      'quantity': 0,
      'unit': 'box',
      'donorId': 'user-1',
      'donorName': 'Ahmed Hassan',
      'status': 'expired',
      'imageUrl': '',
      'category': 'Cardiovascular',
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 200))
          .toIso8601String(),
    },
    {
      'id': 'med-6',
      'name': 'Ibuprofen 400mg',
      'description': 'Non-steroidal anti-inflammatory drug',
      'expiryDate': DateTime.now()
          .add(const Duration(days: 270))
          .toIso8601String(),
      'quantity': 36,
      'unit': 'strip',
      'donorId': 'user-1',
      'donorName': 'Ahmed Hassan',
      'status': 'approved',
      'imageUrl': '',
      'category': 'Pain Relief',
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 12))
          .toIso8601String(),
    },
    {
      'id': 'med-7',
      'name': 'Aspirin 100mg',
      'description': 'Blood thinner — low dose',
      'expiryDate': DateTime.now()
          .add(const Duration(days: 20))
          .toIso8601String(),
      'quantity': 10,
      'unit': 'strip',
      'donorId': 'user-1',
      'donorName': 'Ahmed Hassan',
      'status': 'approved',
      'imageUrl': '',
      'category': 'Cardiovascular',
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 25))
          .toIso8601String(),
    },
  ];

  static List<Map<String, dynamic>> _buildDefaultDonations() => [
    {
      'id': 'don-1',
      'medicineId': 'med-1',
      'medicineName': 'Amoxicillin 500mg',
      'donorId': 'user-1',
      'donorName': 'Ahmed Hassan',
      'status': 'approved',
      'qrCode': 'QR-DON-001',
      'quantity': 24,
      'unit': 'strip',
      'notes': '',
      'reviewedBy': 'user-3',
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 5))
          .toIso8601String(),
    },
    {
      'id': 'don-2',
      'medicineId': 'med-4',
      'medicineName': 'Metformin 850mg',
      'donorId': 'user-1',
      'donorName': 'Ahmed Hassan',
      'status': 'pending',
      'qrCode': null,
      'quantity': 30,
      'unit': 'box',
      'notes': '',
      'reviewedBy': null,
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
    },
  ];

  static List<Map<String, dynamic>> _buildDefaultRequests() => [
    {
      'id': 'req-1',
      'patientId': 'user-2',
      'patientName': 'Sara Mohamed',
      'patientNationalId': '29505057654321',
      'medicineId': 'med-2',
      'medicineName': 'Paracetamol 500mg',
      'quantity': 10,
      'status': 'approved',
      'isUrgent': false,
      'reason': 'Needed for chronic pain management',
      'qrCode': 'QR-REQ-001',
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 2))
          .toIso8601String(),
    },
    {
      'id': 'req-2',
      'patientId': 'user-2',
      'patientName': 'Sara Mohamed',
      'patientNationalId': '29505057654321',
      'medicineId': 'med-3',
      'medicineName': 'Omeprazole 20mg',
      'quantity': 7,
      'status': 'pending',
      'isUrgent': true,
      'reason': 'Urgent: severe acid reflux episodes',
      'qrCode': null,
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'صيدلية النور',
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 6))
          .toIso8601String(),
    },
  ];

  static List<Map<String, dynamic>> _buildDefaultNotifications() => [
    {
      'id': 'notif-1',
      'title': 'Donation Approved',
      'body':
          'Your donation of Amoxicillin 500mg has been approved by the pharmacist.',
      'type': 'donationApproved',
      'isRead': false,
      'userId': 'user-1',
      'targetRole': 'user',
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 2))
          .toIso8601String(),
    },
    {
      'id': 'notif-2',
      'title': 'New Request',
      'body': 'Sara Mohamed has requested Paracetamol 500mg.',
      'type': 'newRequest',
      'isRead': false,
      'userId': 'user-3', // Scoped to seed pharmacist only
      'targetRole': 'pharmacist',
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 3))
          .toIso8601String(),
    },
    {
      'id': 'notif-3',
      'title': 'Request Approved',
      'body':
          'Your request for Paracetamol 500mg has been approved. Show QR code for pickup.',
      'type': 'requestApproved',
      'isRead': true,
      'userId': 'user-2', // Private notification
      'targetRole': 'user',
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
    },
  ];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));

    final path = options.path;
    final method = options.method;

    try {
      Response response;

      // ─── AUTH ───
      if (path.contains('/auth/login') && method == 'POST') {
        response = _handleLogin(options);
      } else if (path.contains('/auth/register') && method == 'POST') {
        response = _handleRegister(options);
      } else if (path.contains('/auth/profile') && method == 'GET') {
        response = _handleGetProfile(options);
      } else if (path.contains('/auth/profile') && method == 'POST') {
        response = _handleUpdateProfile(options);

        // ─── PHARMACIES ─── (must be before /pharmacist routes)
      } else if (path.contains('/pharmacies/pharmacist/') && method == 'GET') {
        response = _handleGetPharmacyByPharmacist(options);
      } else if (path.contains('/pharmacies') && method == 'GET') {
        response = _handleGetPharmacies(options);

        // ─── DONATIONS ───
      } else if (path.contains('/donations/pending') && method == 'GET') {
        response = _handleGetPendingDonations(options);
      } else if (path.contains('/donations') &&
          method == 'GET' &&
          !path.contains('/donations/')) {
        response = _handleGetDonations(options);
      } else if (path.contains('/donations') && method == 'POST') {
        if (path.endsWith('/status')) {
          response = _handleUpdateDonationStatus(options);
        } else {
          response = _handleCreateDonation(options);
        }

        // ─── MEDICINES ───
      } else if (path.contains('/medicines/search') && method == 'GET') {
        response = _handleSearchMedicines(options);
      } else if (path.contains('/medicines') && method == 'GET') {
        response = _handleGetMedicines(options);

        // ─── REQUESTS ───
      } else if (path.contains('/requests') && method == 'GET') {
        response = _handleGetRequests(options);
      } else if (path.contains('/requests') && method == 'POST') {
        if (path.endsWith('/status')) {
          response = _handleUpdateRequestStatus(options);
        } else {
          response = _handleCreateRequest(options);
        }

        // ─── PHARMACIST ───
      } else if (path.contains('/pharmacist/review') && method == 'POST') {
        response = _handleReviewDonation(options);
      } else if (path.contains('/pharmacist/approve-request') &&
          method == 'POST') {
        response = _handleApproveRequest(options);

        // ─── QR ───
      } else if (path.contains('/qr/verify') && method == 'POST') {
        response = _handleVerifyQr(options);

        // ─── NOTIFICATIONS ───
      } else if (path.contains('/notifications/read/') && method == 'POST') {
        response = _handleMarkRead(options);
      } else if (path.contains('/notifications/') && method == 'DELETE') {
        response = _handleDismissNotification(options);
      } else if (path.contains('/notifications') && method == 'GET') {
        response = _handleGetNotifications(options);
      } else {
        response = Response(
          requestOptions: options,
          statusCode: 404,
          data: {'error': 'Endpoint not found'},
        );
      }

      // Fix #4: Error responses must be rejected so Dio's onError fires
      if (response.statusCode != null && response.statusCode! >= 400) {
        handler.reject(
          DioException(
            requestOptions: options,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      } else {
        handler.resolve(response);
      }
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 500,
            data: {'error': e.toString()},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
    }
  }

  // ─── AUTH HANDLERS ───

  Response _handleLogin(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final email = data?['email'] ?? '';
    final password = data?['password'] ?? '';

    if (email.isEmpty || password.isEmpty) {
      return Response(
        requestOptions: options,
        statusCode: 400,
        data: {'error': 'Email and password are required'},
      );
    }

    final user = _users.where((u) => u['email'] == email).firstOrNull;
    if (user == null) {
      return Response(
        requestOptions: options,
        statusCode: 401,
        data: {'error': 'Invalid email or password'},
      );
    }

    // Validate password against stored seed value
    if (password != user['password']) {
      return Response(
        requestOptions: options,
        statusCode: 401,
        data: {'error': 'Invalid email or password'},
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'success': true, 'data': Map<String, dynamic>.from(user)},
    );
  }

  Response _handleRegister(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;

    // Normalize role — treat old 'donor'/'patient' as 'user'
    final rawRole = data?['role'] ?? 'user';
    final role = (rawRole == 'donor' || rawRole == 'patient') ? 'user' : rawRole;

    final id = 'user-${_uuid.v4().substring(0, 8)}';
    final newUser = {
      'id': id,
      'name': data?['name'] ?? '',
      'email': data?['email'] ?? '',
      'phone': data?['phone'] ?? '',
      'nationalId': data?['nationalId'] ?? '',
      'role': role,
      'password': data?['password'] ?? '',
      'status': 'verified',
      'token': 'mock-jwt-token-$id',
      'createdAt': DateTime.now().toIso8601String(),
    };
    _users.add(newUser);

    // Auto-create pharmacy when pharmacist registers
    if (data?['role'] == 'pharmacist') {
      _pharmacies.add({
        'id': 'pharm-${_uuid.v4().substring(0, 8)}',
        'name': data?['pharmacyName'] ?? 'صيدلية جديدة',
        'pharmacistId': id,
        'governorate': data?['governorate'] ?? '',
        'city': data?['city'] ?? '',
        'district': data?['village'] ?? '',
        'address': data?['street'] ?? '',
        'isActive': true,
      });
    }

    return Response(
      requestOptions: options,
      statusCode: 201,
      data: {'success': true, 'data': Map<String, dynamic>.from(newUser)},
    );
  }

  Response _handleGetProfile(RequestOptions options) {
    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';
    final user = _users.where((u) => u['token'] == token).firstOrNull;

    if (user == null) {
      return Response(
        requestOptions: options,
        statusCode: 401,
        data: {'error': 'Unauthorized'},
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'success': true, 'data': Map<String, dynamic>.from(user)},
    );
  }

  Response _handleUpdateProfile(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';

    final index = _users.indexWhere((u) => u['token'] == token);
    if (index < 0) {
      return Response(
        requestOptions: options,
        statusCode: 401,
        data: {'error': 'Unauthorized'},
      );
    }

    // Update user in mock store
    if (data?['name'] != null) _users[index]['name'] = data!['name'];
    if (data?['email'] != null) _users[index]['email'] = data!['email'];
    if (data?['phone'] != null) _users[index]['phone'] = data!['phone'];
    if (data?['pharmacyName'] != null) {
      _users[index]['pharmacyName'] = data!['pharmacyName'];
    }
    if (data?['governorate'] != null) {
      _users[index]['governorate'] = data!['governorate'];
    }
    if (data?['city'] != null) {
      _users[index]['city'] = data!['city'];
    }
    if (data?['village'] != null) {
      _users[index]['village'] = data!['village'];
    }
    if (data?['street'] != null) {
      _users[index]['street'] = data!['street'];
    }
    if (data?['profilePicturePath'] != null) {
      _users[index]['profilePicturePath'] = data!['profilePicturePath'];
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'success': true, 'data': Map<String, dynamic>.from(_users[index])},
    );
  }

  // ─── PHARMACY HANDLERS ───

  Response _handleGetPharmacies(RequestOptions options) {
    final gov = options.queryParameters['governorate'];
    final city = options.queryParameters['city'];
    final district = options.queryParameters['district'];

    var result = List<Map<String, dynamic>>.from(
      _pharmacies,
    ).where((p) => p['isActive'] == true).toList();

    if (gov != null) {
      result = result.where((p) => p['governorate'] == gov).toList();
    }
    if (city != null) {
      result = result.where((p) => p['city'] == city).toList();
    }
    if (district != null) {
      result = result.where((p) => p['district'] == district).toList();
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'data': result.map((p) => Map<String, dynamic>.from(p)).toList(),
      },
    );
  }

  Response _handleGetPharmacyByPharmacist(RequestOptions options) {
    final pharmacistId = options.path.split('/').last;
    final pharmacy = _pharmacies
        .where((p) => p['pharmacistId'] == pharmacistId)
        .firstOrNull;

    if (pharmacy == null) {
      return Response(
        requestOptions: options,
        statusCode: 404,
        data: {'error': 'No pharmacy found for this pharmacist'},
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'success': true, 'data': Map<String, dynamic>.from(pharmacy)},
    );
  }

  // ─── DONATION HANDLERS ───

  Response _handleGetDonations(RequestOptions options) {
    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';
    final user = _users.where((u) => u['token'] == token).firstOrNull;

    List<Map<String, dynamic>> result = _donations;

    if (user != null) {
      if (user['role'] == 'user') {
        // Donor sees only his own donations
        result = _donations.where((d) => d['donorId'] == user['id']).toList();
      } else if (user['role'] == 'pharmacist') {
        // Pharmacist sees only donations for his pharmacy
        final pharmacy = _pharmacies
            .where((p) => p['pharmacistId'] == user['id'])
            .firstOrNull;
        if (pharmacy != null) {
          result = _donations
              .where((d) => d['pharmacyId'] == pharmacy['id'])
              .toList();
        }
      }
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'data': result.map((d) => Map<String, dynamic>.from(d)).toList(),
      },
    );
  }

  Response _handleUpdateDonationStatus(RequestOptions options) {
    final pathParts = options.path.split('/');
    final id = pathParts[pathParts.indexOf('donations') + 1];
    final data = options.data as Map<String, dynamic>?;
    final status = data?['status'];

    final index = _donations.indexWhere((d) => d['id'] == id);
    if (index >= 0) {
      _donations[index] = Map<String, dynamic>.from(_donations[index])
        ..['status'] = status;
      // Issue #2: Mark medicine as approved only upon delivery
      if (status == 'delivered') {
        final medId = _donations[index]['medicineId'];
        final medIndex = _medicines.indexWhere((m) => m['id'] == medId);
        if (medIndex >= 0) {
          _medicines[medIndex]['status'] = 'approved';
        }
      }
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {'success': true, 'data': _donations[index]},
      );
    }
    return Response(
      requestOptions: options,
      statusCode: 404,
      data: {'error': 'Donation not found'},
    );
  }

  Response _handleGetPendingDonations(RequestOptions options) {
    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';
    final user = _users.where((u) => u['token'] == token).firstOrNull;

    var pending = _donations.where((d) => d['status'] == 'pending').toList();

    // Pharmacist sees only pending donations for his pharmacy
    if (user != null && user['role'] == 'pharmacist') {
      final pharmacy = _pharmacies
          .where((p) => p['pharmacistId'] == user['id'])
          .firstOrNull;
      if (pharmacy != null) {
        pending = pending
            .where((d) => d['pharmacyId'] == pharmacy['id'])
            .toList();
      }
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'data': pending.map((d) => Map<String, dynamic>.from(d)).toList(),
      },
    );
  }

  Response _handleCreateDonation(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final medId = 'med-${_uuid.v4().substring(0, 8)}';
    final donId = 'don-${_uuid.v4().substring(0, 8)}';

    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';
    final user = _users.where((u) => u['token'] == token).firstOrNull;

    // Create the medicine entry
    final medicine = {
      'id': medId,
      'name': data?['name'] ?? '',
      'description': data?['description'] ?? '',
      'expiryDate':
          data?['expiryDate'] ??
          DateTime.now().add(const Duration(days: 180)).toIso8601String(),
      'quantity': data?['quantity'] ?? 1,
      'unit': data?['unit'] ?? 'box', // Handle unit
      'donorId': user?['id'] ?? 'unknown',
      'donorName': user?['name'] ?? 'Unknown',
      'status': 'pending',
      'imageUrl': '',
      'category': data?['category'] ?? 'General',
      'pharmacyId': data?['pharmacyId'],
      'pharmacyName': data?['pharmacyName'],
      'createdAt': DateTime.now().toIso8601String(),
    };
    _medicines.add(medicine);

    // Create matching donation record
    final donation = {
      'id': donId,
      'medicineId': medId,
      'medicineName': data?['name'] ?? '',
      'donorId': user?['id'] ?? 'unknown',
      'donorName': user?['name'] ?? 'Unknown',
      'status': 'pending',
      'qrCode': null,
      'quantity': data?['quantity'] ?? 1,
      'unit': data?['unit'] ?? 'box', // Handle unit
      'notes': '',
      'boxImagePath': data?['boxImagePath'],
      'reviewedBy': null,
      'pharmacyId': data?['pharmacyId'],
      'pharmacyName': data?['pharmacyName'],
      'createdAt': DateTime.now().toIso8601String(),
    };
    _donations.add(donation);

    // Notify the pharmacist of the target pharmacy about the new donation
    final pharmacyId = data?['pharmacyId'] as String?;
    if (pharmacyId != null) {
      final pharmacy = _pharmacies
          .where((p) => p['id'] == pharmacyId)
          .firstOrNull;
      if (pharmacy != null) {
        final pharmacistId = pharmacy['pharmacistId'] as String?;
        _addNotification(
          userId: pharmacistId,
          title: 'New Donation Received',
          body:
              'A new donation of ${data?['name'] ?? 'medicine'} has been submitted for review.',
          type: 'newDonation',
        );
      }
    }

    return Response(
      requestOptions: options,
      statusCode: 201,
      data: {'success': true, 'data': Map<String, dynamic>.from(donation)},
    );
  }

  // ─── MEDICINE HANDLERS ───

  Response _handleGetMedicines(RequestOptions options) {
    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';
    final user = _users.where((u) => u['token'] == token).firstOrNull;

    var result = _medicines.where((m) => m['status'] == 'approved').toList();

    // Issue #1: Pharmacist sees ONLY his pharmacy's medicines
    if (user != null && user['role'] == 'pharmacist') {
      final pharmacy = _pharmacies
          .where((p) => p['pharmacistId'] == user['id'])
          .firstOrNull;
      if (pharmacy != null) {
        result = result
            .where((m) => m['pharmacyId'] == pharmacy['id'])
            .toList();
      }
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'data': result.map((m) => Map<String, dynamic>.from(m)).toList(),
      },
    );
  }

  Response _handleSearchMedicines(RequestOptions options) {
    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';
    final user = _users.where((u) => u['token'] == token).firstOrNull;
    final query = (options.queryParameters['q'] ?? '').toString().toLowerCase();

    var results = _medicines
        .where(
          (m) =>
              m['status'] == 'approved' &&
              (m['name'].toString().toLowerCase().contains(query) ||
                  m['category'].toString().toLowerCase().contains(query)),
        )
        .toList();

    // Issue #1: Pharmacist sees ONLY his pharmacy's medicines
    if (user != null && user['role'] == 'pharmacist') {
      final pharmacy = _pharmacies
          .where((p) => p['pharmacistId'] == user['id'])
          .firstOrNull;
      if (pharmacy != null) {
        results = results
            .where((m) => m['pharmacyId'] == pharmacy['id'])
            .toList();
      }
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'data': results.map((m) => Map<String, dynamic>.from(m)).toList(),
      },
    );
  }

  // ─── REQUEST HANDLERS ───

  Response _handleGetRequests(RequestOptions options) {
    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';
    final user = _users.where((u) => u['token'] == token).firstOrNull;

    List<Map<String, dynamic>> result = _requests;
    if (user != null) {
      if (user['role'] == 'user') {
        result = _requests.where((r) => r['patientId'] == user['id']).toList();
      } else if (user['role'] == 'pharmacist') {
        // Pharmacist sees only requests for his pharmacy
        final pharmacy = _pharmacies
            .where((p) => p['pharmacistId'] == user['id'])
            .firstOrNull;
        if (pharmacy != null) {
          result = _requests
              .where((r) => r['pharmacyId'] == pharmacy['id'])
              .toList();
        }
      }
    }

    // Sort: urgent first, then by date
    result.sort((a, b) {
      if (a['isUrgent'] == true && b['isUrgent'] != true) return -1;
      if (b['isUrgent'] == true && a['isUrgent'] != true) return 1;
      return DateTime.parse(
        b['createdAt'],
      ).compareTo(DateTime.parse(a['createdAt']));
    });

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'data': result.map((r) => Map<String, dynamic>.from(r)).toList(),
      },
    );
  }

  Response _handleUpdateRequestStatus(RequestOptions options) {
    final pathParts = options.path.split('/');
    final id = pathParts[pathParts.indexOf('requests') + 1];
    final data = options.data as Map<String, dynamic>?;
    final status = data?['status'];

    final index = _requests.indexWhere((r) => r['id'] == id);
    if (index >= 0) {
      _requests[index] = Map<String, dynamic>.from(_requests[index])
        ..['status'] = status;
      // Issue #3: Stock decreases only after patient receives it
      if (status == 'delivered') {
        final medId = _requests[index]['medicineId'];
        final medIndex = _medicines.indexWhere((m) => m['id'] == medId);
        if (medIndex >= 0) {
          final currentQty = _medicines[medIndex]['quantity'] as int;
          final unit =
              _medicines[medIndex]['unit']?.toString().toLowerCase() ?? 'box';
          final approvedBoxes = _requests[index]['approvedBoxes'] as int? ?? 0;
          final approvedStrips =
              _requests[index]['approvedStrips'] as int? ?? 0;
          final deducted = unit == 'strip' ? approvedStrips : approvedBoxes;
          _medicines[medIndex]['quantity'] = (currentQty - deducted).clamp(
            0,
            currentQty,
          );
        }
      }
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {'success': true, 'data': _requests[index]},
      );
    }
    return Response(
      requestOptions: options,
      statusCode: 404,
      data: {'error': 'Request not found'},
    );
  }

  Response _handleCreateRequest(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';
    final user = _users.where((u) => u['token'] == token).firstOrNull;

    // Check stock
    final med = _medicines
        .where((m) => m['id'] == data?['medicineId'])
        .firstOrNull;
    if (med == null || (med['quantity'] as int) <= 0) {
      return Response(
        requestOptions: options,
        statusCode: 400,
        data: {'error': 'Medicine is out of stock'},
      );
    }

    final reqId = 'req-${_uuid.v4().substring(0, 8)}';
    final request = {
      'id': reqId,
      'patientId': user?['id'] ?? 'unknown',
      'patientName': user?['name'] ?? 'Unknown',
      'patientNationalId': user?['nationalId'] ?? 'Unknown',
      'medicineId': data?['medicineId'] ?? '',
      'medicineName': med['name'],
      'quantity': data?['quantity'] ?? 1,
      'unit': med['unit'] ?? 'box', // Propagate unit from medicine
      'status': 'pending',
      'isUrgent': data?['isUrgent'] ?? false,
      'reason': data?['reason'] ?? '',
      'prescriptionPath': data?['prescriptionPath'],
      'qrCode': null,
      'pharmacyId': med['pharmacyId'],
      'pharmacyName': med['pharmacyName'],
      'createdAt': DateTime.now().toIso8601String(),
    };
    _requests.add(request);

    // Notify the pharmacist of the target pharmacy about the new request
    final pharmacyId = med['pharmacyId'] as String?;
    if (pharmacyId != null) {
      final pharmacy = _pharmacies
          .where((p) => p['id'] == pharmacyId)
          .firstOrNull;
      if (pharmacy != null) {
        final pharmacistId = pharmacy['pharmacistId'] as String?;
        _addNotification(
          userId: pharmacistId,
          title: 'New Medicine Request',
          body:
              '${user?['name'] ?? 'A patient'} has requested ${med['name'] ?? 'medicine'}.',
          type: 'newRequest',
        );
      }
    }

    return Response(
      requestOptions: options,
      statusCode: 201,
      data: {'success': true, 'data': Map<String, dynamic>.from(request)},
    );
  }

  // ─── PHARMACIST HANDLERS ───

  /// Extracts the authenticated user from the token and asserts pharmacist role.
  /// Returns the pharmacist user on success, or a Response error on failure.
  ({Map<String, dynamic>? user, Response? error}) _requirePharmacist(
      RequestOptions options) {
    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';
    final user = _users.where((u) => u['token'] == token).firstOrNull;
    if (user == null) {
      return (
        user: null,
        error: Response(
          requestOptions: options,
          statusCode: 401,
          data: {'error': 'Unauthorized'},
        ),
      );
    }
    if (user['role'] != 'pharmacist') {
      return (
        user: null,
        error: Response(
          requestOptions: options,
          statusCode: 403,
          data: {'error': 'Forbidden: pharmacist role required'},
        ),
      );
    }
    return (user: user, error: null);
  }

  Response _handleReviewDonation(RequestOptions options) {
    final (:user, :error) = _requirePharmacist(options);
    if (error != null) return error;

    final data = options.data as Map<String, dynamic>?;
    final donationId = data?['donationId'] ?? '';
    final action = data?['action'] ?? ''; // 'approve' or 'reject'

    final donIndex = _donations.indexWhere((d) => d['id'] == donationId);
    if (donIndex < 0) {
      return Response(
        requestOptions: options,
        statusCode: 404,
        data: {'error': 'Donation not found'},
      );
    }

    if (action == 'approve') {
      _donations[donIndex]['status'] = 'approved';
      _donations[donIndex]['qrCode'] =
          'QR-DON-${_uuid.v4().substring(0, 6).toUpperCase()}';

      // Issue #2: DO NOT set medicine status to approved yet
      // final medId = _donations[donIndex]['medicineId'];
      // final medIndex = _medicines.indexWhere((m) => m['id'] == medId);
      // if (medIndex >= 0) { ... }
    } else {
      _donations[donIndex]['status'] = 'rejected';
    }
    _donations[donIndex]['notes'] = data?['notes'] ?? '';

    // Generate notification for donor
    final donorId = _donations[donIndex]['donorId'] as String?;
    final medicineName = _donations[donIndex]['medicineName'] ?? 'Medicine';

    if (action == 'approve') {
      _addNotification(
        userId: donorId,
        title: 'Donation Approved',
        body: 'Your donation of $medicineName has been approved. Thank you!',
        type: 'donationApproved',
      );
    } else {
      _addNotification(
        userId: donorId,
        title: 'Donation Rejected',
        body:
            'Your donation of $medicineName was rejected. You may re-donate to another pharmacy.',
        type: 'donationRejected',
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'data': Map<String, dynamic>.from(_donations[donIndex]),
      },
    );
  }

  Response _handleApproveRequest(RequestOptions options) {
    final (:user, :error) = _requirePharmacist(options);
    if (error != null) return error;

    final data = options.data as Map<String, dynamic>?;
    final requestId = data?['requestId'] ?? '';
    final action = data?['action'] ?? '';

    final reqIndex = _requests.indexWhere((r) => r['id'] == requestId);
    if (reqIndex < 0) {
      return Response(
        requestOptions: options,
        statusCode: 404,
        data: {'error': 'Request not found'},
      );
    }

    if (action == 'approve') {
      _requests[reqIndex]['status'] = 'approved';
      _requests[reqIndex]['qrCode'] =
          'QR-REQ-${_uuid.v4().substring(0, 6).toUpperCase()}';
      _requests[reqIndex]['approvedBoxes'] = data?['approvedBoxes'] ?? 0;
      _requests[reqIndex]['approvedStrips'] = data?['approvedStrips'] ?? 0;
      _requests[reqIndex]['reviewedBy'] = user?['id'];
      _requests[reqIndex]['reviewedAt'] = DateTime.now().toIso8601String();

      // Issue #3: DO NOT decrease stock right away
      // Stock is reduced in _handleUpdateRequestStatus when request status becomes 'delivered'
    } else {
      _requests[reqIndex]['status'] = 'rejected';
      _requests[reqIndex]['approvedBoxes'] = data?['approvedBoxes'] ?? 0;
      _requests[reqIndex]['approvedStrips'] = data?['approvedStrips'] ?? 0;
      _requests[reqIndex]['reviewReason'] = data?['reviewReason'];
      _requests[reqIndex]['reviewedBy'] = user?['id'];
      _requests[reqIndex]['reviewedAt'] = DateTime.now().toIso8601String();
    }

    // Generate notification for patient
    final patientId = _requests[reqIndex]['patientId'] as String?;
    final reqMedicineName = _requests[reqIndex]['medicineName'] ?? 'Medicine';

    if (action == 'approve') {
      _addNotification(
        userId: patientId,
        title: 'Request Approved',
        body:
            'Your request for $reqMedicineName has been approved. Visit the pharmacy for pickup.',
        type: 'requestApproved',
      );
    } else {
      _addNotification(
        userId: patientId,
        title: 'Request Rejected',
        body:
            'Your request for $reqMedicineName was rejected. You may submit a new request.',
        type: 'requestRejected',
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'data': Map<String, dynamic>.from(_requests[reqIndex]),
      },
    );
  }

  // ─── QR HANDLERS ───

  Response _handleVerifyQr(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final qrCode = data?['qrCode'] ?? '';

    // Check donations
    final donation = _donations.where((d) => d['qrCode'] == qrCode).firstOrNull;
    if (donation != null) {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'success': true,
          'verified': true,
          'type': 'donation',
          'data': Map<String, dynamic>.from(donation),
        },
      );
    }

    // Check requests
    final request = _requests.where((r) => r['qrCode'] == qrCode).firstOrNull;
    if (request != null) {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'success': true,
          'verified': true,
          'type': 'request',
          'data': Map<String, dynamic>.from(request),
        },
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'verified': false,
        'message': 'QR code not recognized',
      },
    );
  }

  /// Helper to add a notification to the in-memory store
  void _addNotification({
    required String? userId, // null = role-wide
    String? targetRole, // used when userId is null
    required String title,
    required String body,
    required String type,
  }) {
    _notifications.add({
      'id': 'notif-${_uuid.v4().substring(0, 8)}',
      'title': title,
      'body': body,
      'type': type,
      'isRead': false,
      'userId': userId,
      'targetRole': targetRole,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // ─── NOTIFICATION HANDLERS ───

  Response _handleGetNotifications(RequestOptions options) {
    final token =
        options.headers['Authorization']?.toString().replaceFirst(
          'Bearer ',
          '',
        ) ??
        '';
    final user = _users.where((u) => u['token'] == token).firstOrNull;

    if (user == null) {
      return Response(
        requestOptions: options,
        statusCode: 401,
        data: {'error': 'Unauthorized'},
      );
    }

    // Filter by userId OR targetRole matching user's role
    final List<Map<String, dynamic>> result = _notifications.where((n) {
      final isForThisUser = n['userId'] == user['id'];
      final isRoleWide = n['userId'] == null && n['targetRole'] == user['role'];
      return isForThisUser || isRoleWide;
    }).toList();

    // Add expiry warnings for pharmacist role
    if (user['role'] == 'pharmacist') {
      final pharmacy = _pharmacies
          .where((p) => p['pharmacistId'] == user['id'])
          .firstOrNull;

      if (pharmacy != null) {
        final now = DateTime.now();
        final expiringSoon = _medicines.where((m) {
          if (m['pharmacyId'] != pharmacy['id']) return false;
          if (m['status'] != 'approved') return false;
          final expiryDate = DateTime.tryParse(m['expiryDate'] ?? '');
          if (expiryDate == null) return false;
          final daysLeft = expiryDate.difference(now).inDays;
          return daysLeft >= 0 && daysLeft <= 30;
        }).toList();

        for (final med in expiringSoon) {
          final expiryDate = DateTime.parse(med['expiryDate']);
          final daysLeft = expiryDate.difference(now).inDays;
          final medName = med['name'] ?? 'دواء';

          // Avoid duplicate expiry warnings for same medicine
          final alreadyExists = result.any(
            (n) =>
                n['type'] == 'expiryWarning' &&
                n['body']?.toString().contains(medName) == true,
          );

          if (!_dismissedExpiryIds.contains('expiry-${med['id']}') &&
              !alreadyExists) {
            result.add({
              'id': 'expiry-${med['id']}',
              'title': 'Expiry Warning',
              'body': '$medName expires in $daysLeft days',
              'type': 'expiryWarning',
              'isRead': false,
              'userId': user['id'],
              'targetRole': 'pharmacist',
              'createdAt': expiryDate
                  .subtract(const Duration(days: 30))
                  .toIso8601String(),
            });
          }
        }
      }
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'data': result.map((n) => Map<String, dynamic>.from(n)).toList(),
      },
    );
  }

  Response _handleMarkRead(RequestOptions options) {
    final id = options.path.split('/').last;

    if (id.startsWith('expiry-')) {
      // Expiry warnings are dynamic — track dismissal separately
      _dismissedExpiryIds.add(id);
    } else {
      // Mark notification as read (not delete)
      final idx = _notifications.indexWhere((n) => n['id'] == id);
      if (idx >= 0) {
        _notifications[idx]['isRead'] = true;
      }
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'success': true},
    );
  }

  /// Permanently delete a notification from the store
  Response _handleDismissNotification(RequestOptions options) {
    final id = options.path.split('/').last;

    if (id.startsWith('expiry-')) {
      _dismissedExpiryIds.add(id);
    } else {
      _notifications.removeWhere((n) => n['id'] == id);
    }

    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {'success': true},
    );
  }
}
