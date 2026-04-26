import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../data/models/request_model.dart';
import '../../../domain/repositories/request_repository.dart';
import '../auth/auth_bloc.dart';

// ─── ENUMS ───

enum RequestReviewAction { approve, reject }

// ─── EVENTS ───

abstract class RequestEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestsFetchRequested extends RequestEvent {}

class RequestCreateRequested extends RequestEvent {
  final String medicineId;
  final int quantity;
  final bool isUrgent;
  final String reason;
  final String? prescriptionPath;

  RequestCreateRequested({
    required this.medicineId,
    this.quantity = 1,
    required this.isUrgent,
    required this.reason,
    this.prescriptionPath,
  });

  @override
  List<Object?> get props => [medicineId, quantity, isUrgent, prescriptionPath];
}

class RequestApproveRequested extends RequestEvent {
  final String requestId;
  final RequestReviewAction action;
  final int? approvedBoxes;
  final int? approvedStrips;
  final String? reviewReason;

  RequestApproveRequested({
    required this.requestId,
    required this.action,
    this.approvedBoxes,
    this.approvedStrips,
    this.reviewReason,
  });

  @override
  List<Object?> get props => [
    requestId,
    action,
    approvedBoxes,
    approvedStrips,
    reviewReason,
  ];
}

class RequestFinalizeRequested extends RequestEvent {
  final String id;
  RequestFinalizeRequested({required this.id});
  @override
  List<Object?> get props => [id];
}

/// Pagination scaffolding — dispatched when the user scrolls near the bottom.
class LoadMoreRequestsRequested extends RequestEvent {}

// ─── STATES ───

abstract class RequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestsLoaded extends RequestState {
  final List<RequestModel> requests;
  RequestsLoaded({required this.requests});
  @override
  List<Object?> get props => [requests];
}

class RequestCreated extends RequestState {
  final RequestModel request;
  RequestCreated({required this.request});
  @override
  List<Object?> get props => [request];
}

class RequestActionCompleted extends RequestState {
  final RequestModel request;
  final String action;
  RequestActionCompleted({required this.request, required this.action});
  @override
  List<Object?> get props => [request, action];
}

class RequestError extends RequestState {
  final String message;
  RequestError({required this.message});
  @override
  List<Object?> get props => [message];
}

// ─── BLOC ───

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestRepository _service;
  final AuthBloc _authBloc;

  RequestBloc({required RequestRepository service, required AuthBloc authBloc})
    : _service = service,
      _authBloc = authBloc,
      super(RequestInitial()) {
    on<RequestsFetchRequested>(_onFetch);
    on<RequestCreateRequested>(_onCreate);
    on<RequestApproveRequested>(_onApprove);
    on<RequestFinalizeRequested>(_onFinalize);
    on<LoadMoreRequestsRequested>(_onLoadMore);
  }

  Future<void> _onFetch(
    RequestsFetchRequested event,
    Emitter<RequestState> emit,
  ) async {
    emit(RequestLoading());
    try {
      final requests = await _service.getRequests();
      emit(RequestsLoaded(requests: requests));
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  Future<void> _onCreate(
    RequestCreateRequested event,
    Emitter<RequestState> emit,
  ) async {
    // ─── RBAC GUARD: Only patients can create requests ───
    final authState = _authBloc.state;
    if (authState is AuthAuthenticated) {
      if (!authState.user.canRequestMedicine) {
        emit(
          RequestError(
            message: 'Unauthorized: Only patients can request medicine.',
          ),
        );
        return;
      }
    } else {
      emit(RequestError(message: 'Authentication required.'));
      return;
    }

    emit(RequestLoading());
    try {
      final request = await _service.createRequest(
        medicineId: event.medicineId,
        patientNationalId: authState.user.nationalId, // Pass mandatory ID
        quantity: event.quantity, // Pass the event's quantity
        isUrgent: event.isUrgent,
        reason: event.reason,
        prescriptionPath: event.prescriptionPath,
      );
      emit(RequestCreated(request: request));
    } on Failure catch (e) {
      emit(RequestError(message: e.message));
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  Future<void> _onApprove(
    RequestApproveRequested event,
    Emitter<RequestState> emit,
  ) async {
    emit(RequestLoading());
    try {
      final request = await _service.approveRequest(
        requestId: event.requestId,
        action: event.action.name,
        approvedBoxes: event.approvedBoxes,
        approvedStrips: event.approvedStrips,
        reviewReason: event.reviewReason,
      );
      emit(RequestActionCompleted(request: request, action: event.action.name));
    } on Failure catch (e) {
      emit(RequestError(message: e.message));
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  Future<void> _onFinalize(
    RequestFinalizeRequested event,
    Emitter<RequestState> emit,
  ) async {
    try {
      await _service.updateRequestStatus(event.id, 'delivered');
      final requests = await _service.getRequests();
      emit(RequestsLoaded(requests: requests));
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  // TODO(pagination): Replace with cursor/offset logic when backend is ready.
  Future<void> _onLoadMore(
    LoadMoreRequestsRequested event,
    Emitter<RequestState> emit,
  ) async {
    if (state is RequestsLoaded) return;
  }
}
