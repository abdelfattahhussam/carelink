import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carelink_app/l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/network/dio_client.dart';
import 'package:go_router/go_router.dart';
// Concrete services — needed for instantiation only
import 'data/services/auth_service.dart';
import 'data/services/donation_service.dart';
import 'data/services/medicine_service.dart';
import 'data/services/request_service.dart';
import 'data/services/qr_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/pharmacy_service.dart';
// Repository interfaces — used as field types
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/donation_repository.dart';
import 'domain/repositories/medicine_repository.dart';
import 'domain/repositories/request_repository.dart';
import 'domain/repositories/qr_repository.dart';
import 'domain/repositories/notification_repository.dart';
import 'domain/repositories/pharmacy_repository.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/donation/donation_bloc.dart';
import 'presentation/blocs/medicine/medicine_bloc.dart';
import 'presentation/blocs/request/request_bloc.dart';
import 'presentation/blocs/notification/notification_bloc.dart';
import 'presentation/blocs/qr/qr_bloc.dart';
import 'presentation/blocs/settings/settings_cubit.dart';
import 'presentation/blocs/settings/settings_state.dart';
import 'presentation/blocs/pharmacy/pharmacy_bloc.dart';

/// Root application widget with all BLoC providers
class CareLinkApp extends StatefulWidget {
  const CareLinkApp({super.key});

  @override
  State<CareLinkApp> createState() => _CareLinkAppState();
}

class _CareLinkAppState extends State<CareLinkApp> {
  // ─── Services & BLoCs created once during initState ───
  late final AuthBloc _authBloc;
  late final GoRouter _router;
  late final AuthRepository _authService;
  late final DonationRepository _donationService;
  late final MedicineRepository _medicineService;
  late final RequestRepository _requestService;
  late final QrRepository _qrService;
  late final NotificationRepository _notificationService;
  late final PharmacyRepository _pharmacyService;

  @override
  void initState() {
    super.initState();

    // 1. Create AuthBloc first (empty — no service yet)
    _authBloc = AuthBloc.empty();

    // 2. Create DioClient with AuthBloc so 401s dispatch AuthLogoutRequested
    final dio = DioClient(authBloc: _authBloc).dio;

    // 3. Create all services with the shared Dio instance
    _authService = AuthService(dio: dio);
    _donationService = DonationService(dio: dio);
    _medicineService = MedicineService(dio: dio);
    _requestService = RequestService(dio: dio);
    _qrService = QrService(dio: dio);
    _notificationService = NotificationService(dio: dio);
    _pharmacyService = PharmacyService(dio: dio);

    // 4. Now bind service to AuthBloc and trigger initial auth check
    _authBloc.init(service: _authService);

    // 5. Create router once — it must NOT be recreated on theme/language changes
    _router = AppRouter.getRouter(_authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsCubit()..loadSettings()),
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (_) => DonationBloc(service: _donationService)),
        BlocProvider(create: (_) => MedicineBloc(service: _medicineService)),
        BlocProvider(
          create: (_) =>
              RequestBloc(service: _requestService, authBloc: _authBloc),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(
            authBloc: _authBloc,
            service: _notificationService,
          ),
        ),
        BlocProvider(create: (_) => QrBloc(service: _qrService)),
        BlocProvider(create: (_) => PharmacyBloc(service: _pharmacyService)),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            title: 'CareLink',
            debugShowCheckedModeBanner: false,

            // Theme settings
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.themeMode,

            // Localization settings
            locale: settingsState.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', ''), Locale('ar', '')],

            routerConfig: _router,
          );
        },
      ),
    );
  }
}
