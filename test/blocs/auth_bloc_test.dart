import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:carelink_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:carelink_app/domain/repositories/auth_repository.dart';
import 'package:carelink_app/data/models/user_model.dart';
import 'package:carelink_app/core/errors/failures.dart';
import '../helpers/fake_auth_storage.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late FakeAuthStorage fakeStorage;

  final testUser = UserModel(
    id: '1',
    name: 'Test User',
    email: 'test@test.com',
    phone: '01234567890',
    nationalId: '12345678901234',
    role: UserRole.user,
    status: 'verified',
    token: 'mock-token',
    createdAt: DateTime(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(UserRole.user);
  });

  setUp(() {
    mockRepo = MockAuthRepository();
    fakeStorage = FakeAuthStorage();
  });

  AuthBloc buildBloc() {
    return AuthBloc(authService: mockRepo, authStorage: fakeStorage);
  }

  group('AuthBloc — Login', () {
    blocTest<AuthBloc, AuthState>(
      'login success emits [AuthLoading, AuthAuthenticated]',
      build: () {
        when(
          () => mockRepo.login('test@test.com', 'password'),
        ).thenAnswer((_) async => testUser);
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        AuthLoginRequested(email: 'test@test.com', password: 'password'),
      ),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
      verify: (_) async {
        expect(await fakeStorage.read('auth_token'), 'mock-token');
      },
    );

    blocTest<AuthBloc, AuthState>(
      'login failure emits [AuthLoading, AuthError]',
      build: () {
        when(
          () => mockRepo.login('bad@test.com', 'wrong'),
        ).thenThrow(const ServerFailure(message: 'Invalid'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        AuthLoginRequested(email: 'bad@test.com', password: 'wrong'),
      ),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });

  group('AuthBloc — Register', () {
    blocTest<AuthBloc, AuthState>(
      'register success emits [AuthLoading, AuthAuthenticated]',
      build: () {
        when(
          () => mockRepo.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
            nationalId: any(named: 'nationalId'),
            password: any(named: 'password'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => testUser);
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        AuthRegisterRequested(
          name: 'Test',
          email: 'test@test.com',
          phone: '01234567890',
          nationalId: '12345678901234',
          password: 'pass',
          role: UserRole.user,
        ),
      ),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );
  });

  group('AuthBloc — Logout', () {
    blocTest<AuthBloc, AuthState>(
      'logout clears storage and emits AuthUnauthenticated',
      build: () => buildBloc(),
      seed: () => AuthAuthenticated(user: testUser),
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [isA<AuthUnauthenticated>()],
      verify: (_) async {
        expect(await fakeStorage.read('auth_token'), isNull);
      },
    );
  });

  group('AuthBloc — AuthCheck', () {
    blocTest<AuthBloc, AuthState>(
      'emits AuthAuthenticated when valid session exists',
      setUp: () async {
        await fakeStorage.write('auth_token', 'tok');
        await fakeStorage.write(
          'user_data',
          '{"id":"1","name":"T","email":"t@t.com","phone":"0","nationalId":"0","role":"user","status":"verified","token":"tok","createdAt":"2026-01-01T00:00:00.000"}',
        );
      },
      build: () => buildBloc(),
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthUnauthenticated when no stored session',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
    );
  });
}
