/// Abstract QR code repository contract.
abstract class QrRepository {
  /// Verify a scanned QR code against the backend
  Future<Map<String, dynamic>> verifyQr(String qrCode);

  /// Update status of a donation or request (for confirmation workflow)
  Future<void> updateStatus(String id, String type, String status);
}
