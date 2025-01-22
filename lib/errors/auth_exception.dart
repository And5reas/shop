class AuthException implements Exception {
  static const Map<String, String> errors = {
    'USER_DISABLED': 'Essa conta foi desativada',
    'EMAIL_EXISTS': 'E-mail já cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente, Tente mais tarde',
    'INVALID_LOGIN_CREDENTIALS': 'Usuário ou senha inválido',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro no processo de autenticação';
  }
}
