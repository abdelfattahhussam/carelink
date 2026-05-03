import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/errors/dio_error_mapper.dart';
import '../../../data/models/donation_model.dart';
import '../../../domain/repositories/donation_repository.dart';

// ─── EVENTS ───

abstract class DonationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DonationsFetchRequested extends DonationEvent {}

class PendingDonationsFetchRequested extends DonationEvent {}

enum DonationReviewAction { approve, reject }

class DonationCreateRequested extends DonationEvent {
  final String name;
  final String notes;
  final String expiryDate;
  final int quantity;
  final String unit;
  final String? category;
  final String? boxImagePath;
  final String pharmacyId;
  final String pharmacyName;

  DonationCreateRequested({
    required this.name,
    required this.notes,
    required this.expiryDate,
    required this.quantity,
    required this.unit,
    this.category,
    this.boxImagePath,
    required this.pharmacyId,
    required this.pharmacyName,
  });

  @override
  List<Object?> get props => [
    name,
    notes,
    expiryDate,
    quantity,
    unit,
    category,
    boxImagePath,
    pharmacyId,
    pharmacyName,
  ];
}

class DonationReviewRequested extends DonationEvent {
  final String donationId;
  final DonationReviewAction action;
  final String? notes;

  DonationReviewRequested({
    required this.donationId,
    required this.action,
    this.notes,
  });

  @override
  List<Object?> get props => [donationId, action];
}

class DonationFinalizeRequested extends DonationEvent {
  final String id;
  DonationFinalizeRequested({required this.id});
  @override
  List<Object?> get props => [id];
}

/// Pagination scaffolding — dispatched when the user scrolls near the bottom.
class LoadMoreDonationsRequested extends DonationEvent {}

// ─── STATES ───

abstract class DonationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DonationInitial extends DonationState {}

class DonationLoading extends DonationState {}

class DonationsLoaded extends DonationState {
  final List<DonationModel> donations;
  DonationsLoaded({required this.donations});
  @override
  List<Object?> get props => [donations];
}

class DonationCreated extends DonationState {
  final DonationModel donation;
  DonationCreated({required this.donation});
  @override
  List<Object?> get props => [donation];
}

class DonationReviewed extends DonationState {
  final DonationModel donation;
  final DonationReviewAction action;
  DonationReviewed({required this.donation, required this.action});
  @override
  List<Object?> get props => [donation, action];
}

class DonationError extends DonationState {
  final String message;
  DonationError({required this.message});
  @override
  List<Object?> get props => [message];
}

// ─── BLOC ───

class DonationBloc extends Bloc<DonationEvent, DonationState> {
  final DonationRepository _service;

  DonationBloc({required DonationRepository service})
    : _service = service,
      super(DonationInitial()) {
    on<DonationsFetchRequested>(_onFetchDonations);
    on<PendingDonationsFetchRequested>(_onFetchPendingDonations);
    on<DonationCreateRequested>(_onCreateDonation);
    on<DonationReviewRequested>(_onReviewDonation);
    on<DonationFinalizeRequested>(_onFinalizeDonation);
    on<LoadMoreDonationsRequested>(_onLoadMore);
  }

  Future<void> _onFetchDonations(
    DonationsFetchRequested event,
    Emitter<DonationState> emit,
  ) async {
    emit(DonationLoading());
    try {
      final donations = await _service.getDonations();
      emit(DonationsLoaded(donations: donations));
    } on DioException catch (e) {
      emit(DonationError(message: DioErrorMapper.toMessage(e)));
    } catch (e) {
      emit(DonationError(message: e.toString()));
    }
  }

  Future<void> _onFetchPendingDonations(
    PendingDonationsFetchRequested event,
    Emitter<DonationState> emit,
  ) async {
    emit(DonationLoading());
    try {
      final donations = await _service.getPendingDonations();
      emit(DonationsLoaded(donations: donations));
    } on DioException catch (e) {
      emit(DonationError(message: DioErrorMapper.toMessage(e)));
    } catch (e) {
      emit(DonationError(message: e.toString()));
    }
  }

  Future<void> _onCreateDonation(
    DonationCreateRequested event,
    Emitter<DonationState> emit,
  ) async {
    emit(DonationLoading());
    try {
      final donation = await _service.createDonation(
        name: event.name,
        notes: event.notes,
        expiryDate: event.expiryDate,
        quantity: event.quantity,
        unit: event.unit,
        category: event.category,
        boxImagePath: event.boxImagePath,
        pharmacyId: event.pharmacyId,
        pharmacyName: event.pharmacyName,
      );
      emit(DonationCreated(donation: donation));
    } on DioException catch (e) {
      emit(DonationError(message: DioErrorMapper.toMessage(e)));
    } catch (e) {
      emit(DonationError(message: e.toString()));
    }
  }

  Future<void> _onReviewDonation(
    DonationReviewRequested event,
    Emitter<DonationState> emit,
  ) async {
    emit(DonationLoading());
    try {
      final donation = await _service.reviewDonation(
        donationId: event.donationId,
        action: event.action.name,
        notes: event.notes,
      );
      emit(DonationReviewed(donation: donation, action: event.action));
    } on DioException catch (e) {
      emit(DonationError(message: DioErrorMapper.toMessage(e)));
    } catch (e) {
      emit(DonationError(message: e.toString()));
    }
  }

  Future<void> _onFinalizeDonation(
    DonationFinalizeRequested event,
    Emitter<DonationState> emit,
  ) async {
    emit(DonationLoading());
    try {
      await _service.updateDonationStatus(event.id, 'delivered');
    } catch (e) {
      emit(DonationError(message: e.toString()));
      return;
    }
    try {
      final donations = await _service.getDonations();
      emit(DonationsLoaded(donations: donations));
    } catch (e) {
      emit(DonationError(message: 'Finalized, but failed to refresh list.'));
    }
  }



  // TODO(pagination): Replace with cursor/offset logic when backend is ready.
  Future<void> _onLoadMore(
    LoadMoreDonationsRequested event,
    Emitter<DonationState> emit,
  ) async {
    if (state is! DonationsLoaded) return;
    // TODO: implement cursor/offset pagination
  }
}
