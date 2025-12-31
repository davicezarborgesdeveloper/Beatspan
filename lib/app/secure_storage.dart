import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Gerencia armazenamento seguro de dados sensíveis usando criptografia nativa
///
/// Esta classe usa:
/// - Android: EncryptedSharedPreferences (AES256)
/// - iOS: Keychain
/// - Windows: Credential Store
/// - Linux: Secret Service API / libsecret
/// - Web: Web Crypto API
class SecureStorage {
  // Instância do FlutterSecureStorage com configurações otimizadas
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      resetOnError: true, // Reseta em caso de erro de descriptografia
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock, // Disponível após primeiro unlock
    ),
    webOptions: WebOptions(
      dbName: 'beatspan_secure_db',
      publicKey: 'beatspan_public_key',
    ),
  );

  // ============================================================================
  // Spotify Token
  // ============================================================================

  static const _keySpotifyToken = 'spotify_access_token';
  static const _keySpotifyTokenExpiry = 'spotify_token_expiry';

  /// Salva token de acesso do Spotify com timestamp de expiração
  Future<void> saveSpotifyToken(String token, {DateTime? expiresAt}) async {
    await _storage.write(key: _keySpotifyToken, value: token);

    if (expiresAt != null) {
      await _storage.write(
        key: _keySpotifyTokenExpiry,
        value: expiresAt.toIso8601String(),
      );
    }
  }

  /// Recupera token de acesso do Spotify
  /// Retorna null se token não existir ou estiver expirado
  Future<String?> getSpotifyToken() async {
    final token = await _storage.read(key: _keySpotifyToken);

    if (token == null) return null;

    // Verifica se token está expirado
    final expiryStr = await _storage.read(key: _keySpotifyTokenExpiry);
    if (expiryStr != null) {
      final expiry = DateTime.parse(expiryStr);
      if (DateTime.now().isAfter(expiry)) {
        // Token expirado, remove
        await deleteSpotifyToken();
        return null;
      }
    }

    return token;
  }

  /// Remove token de acesso do Spotify
  Future<void> deleteSpotifyToken() async {
    await _storage.delete(key: _keySpotifyToken);
    await _storage.delete(key: _keySpotifyTokenExpiry);
  }

  /// Verifica se tem um token válido do Spotify
  Future<bool> hasValidSpotifyToken() async {
    final token = await getSpotifyToken();
    return token != null;
  }

  // ============================================================================
  // Tipo de Plano Spotify
  // ============================================================================

  static const _keyPlanType = 'spotify_plan_type';

  /// Salva tipo de plano do Spotify (premium/free)
  Future<void> savePlanType(String planType) async {
    await _storage.write(key: _keyPlanType, value: planType);
  }

  /// Recupera tipo de plano do Spotify
  Future<String?> getPlanType() async {
    return await _storage.read(key: _keyPlanType);
  }

  /// Remove tipo de plano do Spotify
  Future<void> deletePlanType() async {
    return _storage.delete(key: _keyPlanType);
  }

  // ============================================================================
  // Refresh Token (se necessário no futuro)
  // ============================================================================

  static const _keySpotifyRefreshToken = 'spotify_refresh_token';

  /// Salva refresh token do Spotify
  Future<void> saveSpotifyRefreshToken(String refreshToken) async {
    await _storage.write(key: _keySpotifyRefreshToken, value: refreshToken);
  }

  /// Recupera refresh token do Spotify
  Future<String?> getSpotifyRefreshToken() async {
    return await _storage.read(key: _keySpotifyRefreshToken);
  }

  /// Remove refresh token do Spotify
  Future<void> deleteSpotifyRefreshToken() async {
    return _storage.delete(key: _keySpotifyRefreshToken);
  }

  // ============================================================================
  // Operações Gerais
  // ============================================================================

  /// Limpa TODOS os dados seguros (use com cuidado!)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Verifica se tem algum dado armazenado
  Future<bool> hasAnyData() async {
    final all = await _storage.readAll();
    return all.isNotEmpty;
  }

  /// Retorna todas as chaves armazenadas (para debug)
  /// NÃO retorna os valores por segurança
  Future<Set<String>> getAllKeys() async {
    final all = await _storage.readAll();
    return all.keys.toSet();
  }

  // ============================================================================
  // Migração de SharedPreferences (se necessário)
  // ============================================================================

  /// Migra dados de SharedPreferences para SecureStorage
  /// Use apenas uma vez durante a migração
  Future<void> migrateFromSharedPreferences({
    String? oldPlanType,
  }) async {
    // Migra tipo de plano se fornecido
    if (oldPlanType != null && oldPlanType.isNotEmpty) {
      final existing = await getPlanType();
      if (existing == null) {
        await savePlanType(oldPlanType);
      }
    }
  }
}
