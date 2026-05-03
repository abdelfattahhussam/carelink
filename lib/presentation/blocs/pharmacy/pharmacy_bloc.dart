import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../data/models/pharmacy_model.dart';
import '../../../domain/repositories/pharmacy_repository.dart';

// ─── EVENTS ───

abstract class PharmacyEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PharmaciesLoadRequested extends PharmacyEvent {
  final String? governorate;
  final String? city;
  final String? district;
  PharmaciesLoadRequested({this.governorate, this.city, this.district});
  @override
  List<Object?> get props => [governorate, city, district];
}

class PharmacyFilterChanged extends PharmacyEvent {
  final String? governorate;
  final String? city;
  final String? district;
  PharmacyFilterChanged({this.governorate, this.city, this.district});
  @override
  List<Object?> get props => [governorate, city, district];
}

class PharmacySelected extends PharmacyEvent {
  final PharmacyModel pharmacy;
  PharmacySelected(this.pharmacy);
  @override
  List<Object?> get props => [pharmacy];
}

class PharmacySelectionCleared extends PharmacyEvent {}

// ─── STATES ───

abstract class PharmacyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PharmacyInitial extends PharmacyState {}

class PharmacyLoading extends PharmacyState {}

class PharmaciesLoaded extends PharmacyState {
  final List<PharmacyModel> pharmacies;
  final PharmacyModel? selectedPharmacy;
  final String? filterGovernorate;
  final String? filterCity;
  final String? filterDistrict;

  PharmaciesLoaded({
    required this.pharmacies,
    this.selectedPharmacy,
    this.filterGovernorate,
    this.filterCity,
    this.filterDistrict,
  });

  /// Unique governorates from loaded list
  List<String> get governorates =>
      pharmacies.map((p) => p.governorate).toSet().toList()..sort();

  /// Cities filtered by selected governorate
  List<String> get cities {
    if (filterGovernorate == null) return [];
    return pharmacies
        .where((p) => p.governorate == filterGovernorate)
        .map((p) => p.city)
        .toSet()
        .toList()
      ..sort();
  }

  /// Districts filtered by selected city
  List<String> get districts {
    if (filterCity == null) return [];
    return pharmacies
        .where((p) => p.city == filterCity)
        .map((p) => p.district)
        .toSet()
        .toList()
      ..sort();
  }

  /// Pharmacies after applying all filters
  List<PharmacyModel> get filtered {
    return pharmacies.where((p) {
      if (filterGovernorate != null && p.governorate != filterGovernorate) {
        return false;
      }
      if (filterCity != null && p.city != filterCity) {
        return false;
      }
      if (filterDistrict != null && p.district != filterDistrict) {
        return false;
      }
      return p.isActive;
    }).toList();
  }

  PharmaciesLoaded copyWith({
    List<PharmacyModel>? pharmacies,
    PharmacyModel? selectedPharmacy,
    bool clearSelection = false,
    String? filterGovernorate,
    String? filterCity,
    bool clearCity = false,
    String? filterDistrict,
    bool clearDistrict = false,
  }) {
    return PharmaciesLoaded(
      pharmacies: pharmacies ?? this.pharmacies,
      selectedPharmacy: clearSelection
          ? null
          : selectedPharmacy ?? this.selectedPharmacy,
      filterGovernorate: filterGovernorate ?? this.filterGovernorate,
      filterCity: clearCity ? null : filterCity ?? this.filterCity,
      filterDistrict: clearDistrict
          ? null
          : filterDistrict ?? this.filterDistrict,
    );
  }

  @override
  List<Object?> get props => [
    pharmacies,
    selectedPharmacy,
    filterGovernorate,
    filterCity,
    filterDistrict,
  ];
}

class PharmacyError extends PharmacyState {
  final String message;
  PharmacyError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLOC ───

class PharmacyBloc extends Bloc<PharmacyEvent, PharmacyState> {
  final PharmacyRepository _service;

  PharmacyBloc({required PharmacyRepository service})
    : _service = service,
      super(PharmacyInitial()) {
    on<PharmaciesLoadRequested>(_onLoad);
    on<PharmacyFilterChanged>(_onFilterChanged);
    on<PharmacySelected>(_onSelected);
    on<PharmacySelectionCleared>(_onCleared);
  }

  Future<void> _onLoad(
    PharmaciesLoadRequested event,
    Emitter<PharmacyState> emit,
  ) async {
    emit(PharmacyLoading());
    try {
      final pharmacies = await _service.getPharmacies(
        governorate: event.governorate,
        city: event.city,
        district: event.district,
      );
      emit(PharmaciesLoaded(
        pharmacies: pharmacies,
        filterGovernorate: event.governorate,
        filterCity: event.city,
        filterDistrict: event.district,
      ));
    } on Failure catch (e) {
      emit(PharmacyError(e.message));
    } catch (e) {
      emit(PharmacyError(e.toString()));
    }
  }

  void _onFilterChanged(
    PharmacyFilterChanged event,
    Emitter<PharmacyState> emit,
  ) {
    if (state is! PharmaciesLoaded) return;
    final current = state as PharmaciesLoaded;

    // When governorate changes — clear city and district
    if (event.governorate != null &&
        event.governorate != current.filterGovernorate) {
      emit(
        current.copyWith(
          filterGovernorate: event.governorate,
          clearCity: true,
          clearDistrict: true,
          clearSelection: true,
        ),
      );
      return;
    }

    // When city changes — clear district
    if (event.city != null && event.city != current.filterCity) {
      emit(
        current.copyWith(
          filterCity: event.city,
          clearDistrict: true,
          clearSelection: true,
        ),
      );
      return;
    }

    emit(
      current.copyWith(filterDistrict: event.district, clearSelection: true),
    );
  }

  void _onSelected(PharmacySelected event, Emitter<PharmacyState> emit) {
    if (state is! PharmaciesLoaded) return;
    emit(
      (state as PharmaciesLoaded).copyWith(selectedPharmacy: event.pharmacy),
    );
  }

  void _onCleared(PharmacySelectionCleared event, Emitter<PharmacyState> emit) {
    if (state is! PharmaciesLoaded) return;
    emit((state as PharmaciesLoaded).copyWith(clearSelection: true));
  }
}
