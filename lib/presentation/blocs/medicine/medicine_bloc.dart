import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/medicine_model.dart';
import '../../../data/services/medicine_service.dart';

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
  final MedicineService _service;

  MedicineBloc({required MedicineService service})
      : _service = service,
        super(MedicineInitial()) {
    on<MedicinesFetchRequested>(_onFetch);
    on<MedicinesSearchRequested>(_onSearch);
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
}
