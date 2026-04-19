import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/services/qr_service.dart';

// ─── EVENTS ───

abstract class QrEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrVerifyRequested extends QrEvent {
  final String qrCode;
  QrVerifyRequested({required this.qrCode});
  @override
  List<Object?> get props => [qrCode];
}

class QrReset extends QrEvent {}

class QrConfirmProcessed extends QrEvent {
  final String id;
  final String type; // 'donation' or 'request'
  QrConfirmProcessed({required this.id, required this.type});
  @override
  List<Object?> get props => [id, type];
}

// ─── STATES ───

abstract class QrState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrInitial extends QrState {}
class QrLoading extends QrState {}

class QrVerified extends QrState {
  final bool isValid;
  final String type; // 'donation' or 'request'
  final Map<String, dynamic> data;
  final String? message;

  QrVerified({
    required this.isValid,
    required this.type,
    required this.data,
    this.message,
  });

  @override
  List<Object?> get props => [isValid, type, data];
}

class QrError extends QrState {
  final String message;
  QrError({required this.message});
  @override
  List<Object?> get props => [message];
}

// ─── BLOC ───

class QrBloc extends Bloc<QrEvent, QrState> {
  final QrService _service;

  QrBloc({required QrService service})
      : _service = service,
        super(QrInitial()) {
    on<QrVerifyRequested>(_onVerify);
    on<QrReset>(_onReset);
    on<QrConfirmProcessed>(_onConfirm);
  }

  Future<void> _onVerify(
    QrVerifyRequested event,
    Emitter<QrState> emit,
  ) async {
    emit(QrLoading());
    try {
      final result = await _service.verifyQr(event.qrCode);
      final verified = result['verified'] == true;

      emit(QrVerified(
        isValid: verified,
        type: result['type'] ?? '',
        data: verified ? (result['data'] as Map<String, dynamic>? ?? {}) : {},
        message: verified ? null : (result['message'] ?? 'QR code not recognized'),
      ));
    } catch (e) {
      emit(QrError(message: e.toString()));
    }
  }

  void _onReset(QrReset event, Emitter<QrState> emit) {
    emit(QrInitial());
  }

  Future<void> _onConfirm(
    QrConfirmProcessed event,
    Emitter<QrState> emit,
  ) async {
    emit(QrLoading());
    try {
      // API call to mark as 'delivering' (pending user confirmation)
      await _service.updateStatus(event.id, event.type, 'delivering');
      emit(QrInitial()); // Reset after sending the 'signal'
    } catch (e) {
      emit(QrError(message: e.toString()));
    }
  }
}
