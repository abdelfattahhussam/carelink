import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/medicine_model.dart';
import '../../../domain/repositories/medicine_repository.dart';

// ─── EVENTS ───

abstract class MedicineEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MedicinesFetchRequested extends MedicineEvent {}

class MedicinesSearchRequested extends MedicineEvent {
  final String query;
  MedicinesSearchRequested({required this.query});
  @override
  List<Object?> get props => [query];
}

/// Pagination scaffolding — dispatched when the user scrolls near the bottom.
/// Currently re-fetches the full list; swap with cursor/offset logic when
/// the backend supports paginated endpoints.
class LoadMoreMedicinesRequested extends MedicineEvent {}

// ─── STATES ───

abstract class MedicineState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MedicineInitial extends MedicineState {}

class MedicineLoading extends MedicineState {}

class MedicinesLoaded extends MedicineState {
  final List<MedicineModel> medicines;
  MedicinesLoaded({required this.medicines});
  @override
  List<Object?> get props => [medicines];
}

class MedicineError extends MedicineState {
  final String message;
  MedicineError({required this.message});
  @override
  List<Object?> get props => [message];
}

// ─── BLOC ───

class MedicineBloc extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository _service;

  MedicineBloc({required MedicineRepository service})
    : _service = service,
      super(MedicineInitial()) {
    on<MedicinesFetchRequested>(_onFetch);
    on<MedicinesSearchRequested>(_onSearch);
    on<LoadMoreMedicinesRequested>(_onLoadMore);
  }

  Future<void> _onFetch(
    MedicinesFetchRequested event,
    Emitter<MedicineState> emit,
  ) async {
    emit(MedicineLoading());
    try {
      final medicines = await _service.getMedicines();
      emit(MedicinesLoaded(medicines: medicines));
    } catch (e) {
      emit(MedicineError(message: e.toString()));
    }
  }

  Future<void> _onSearch(
    MedicinesSearchRequested event,
    Emitter<MedicineState> emit,
  ) async {
    emit(MedicineLoading());
    try {
      final medicines = await _service.searchMedicines(event.query);
      emit(MedicinesLoaded(medicines: medicines));
    } catch (e) {
      emit(MedicineError(message: e.toString()));
    }
  }

  // TODO(pagination): Replace with cursor/offset logic when backend is ready.
  Future<void> _onLoadMore(
    LoadMoreMedicinesRequested event,
    Emitter<MedicineState> emit,
  ) async {
    // Currently a no-op if already loaded — avoids redundant fetches.
    if (state is MedicinesLoaded) return;
  }
}
