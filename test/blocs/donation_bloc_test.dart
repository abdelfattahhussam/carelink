import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:carelink_app/presentation/blocs/donation/donation_bloc.dart';
import 'package:carelink_app/domain/repositories/donation_repository.dart';
import 'package:carelink_app/data/models/donation_model.dart';
import 'package:carelink_app/data/models/medicine_unit.dart';

class MockDonationRepository extends Mock implements DonationRepository {}

void main() {
  late MockDonationRepository mockRepo;

  final testDonation = DonationModel(
    id: 'd1',
    medicineId: 'm1',
    medicineName: 'Aspirin',
    donorId: 'u1',
    donorName: 'Ahmed',
    status: 'pending',
    quantity: 10,
    unit: MedicineUnit.box,
    notes: '',
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockRepo = MockDonationRepository();
  });

  group('DonationBloc — Fetch', () {
    blocTest<DonationBloc, DonationState>(
      'fetch donations success',
      build: () {
        when(
          () => mockRepo.getDonations(),
        ).thenAnswer((_) async => [testDonation]);
        return DonationBloc(service: mockRepo);
      },
      act: (bloc) => bloc.add(DonationsFetchRequested()),
      expect: () => [isA<DonationLoading>(), isA<DonationsLoaded>()],
    );

    blocTest<DonationBloc, DonationState>(
      'fetch donations failure',
      build: () {
        when(
          () => mockRepo.getDonations(),
        ).thenThrow(DioException(requestOptions: RequestOptions(path: '/')));
        return DonationBloc(service: mockRepo);
      },
      act: (bloc) => bloc.add(DonationsFetchRequested()),
      expect: () => [isA<DonationLoading>(), isA<DonationError>()],
    );

    blocTest<DonationBloc, DonationState>(
      'fetch pending donations success',
      build: () {
        when(
          () => mockRepo.getPendingDonations(),
        ).thenAnswer((_) async => [testDonation]);
        return DonationBloc(service: mockRepo);
      },
      act: (bloc) => bloc.add(PendingDonationsFetchRequested()),
      expect: () => [isA<DonationLoading>(), isA<DonationsLoaded>()],
    );
  });

  group('DonationBloc — Create', () {
    blocTest<DonationBloc, DonationState>(
      'create donation success',
      build: () {
        when(
          () => mockRepo.createDonation(
            name: any(named: 'name'),
            notes: any(named: 'notes'),
            expiryDate: any(named: 'expiryDate'),
            quantity: any(named: 'quantity'),
            unit: any(named: 'unit'),
            pharmacyId: any(named: 'pharmacyId'),
            pharmacyName: any(named: 'pharmacyName'),
          ),
        ).thenAnswer((_) async => testDonation);
        return DonationBloc(service: mockRepo);
      },
      act: (bloc) => bloc.add(
        DonationCreateRequested(
          name: 'Aspirin',
          notes: '',
          expiryDate: '2027-01-01',
          quantity: 10,
          unit: 'box',
          pharmacyId: 'p1',
          pharmacyName: 'Test',
        ),
      ),
      expect: () => [isA<DonationLoading>(), isA<DonationCreated>()],
    );
  });

  group('DonationBloc — Review', () {
    blocTest<DonationBloc, DonationState>(
      'review donation (approve) success',
      build: () {
        when(
          () => mockRepo.reviewDonation(
            donationId: 'd1',
            action: 'approve',
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => testDonation);
        return DonationBloc(service: mockRepo);
      },
      act: (bloc) => bloc.add(
        DonationReviewRequested(
          donationId: 'd1',
          action: DonationReviewAction.approve,
        ),
      ),
      expect: () => [isA<DonationLoading>(), isA<DonationReviewed>()],
    );
  });
}
