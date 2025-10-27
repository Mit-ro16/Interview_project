import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview_portal/core/shared_prefs/shared_prefs.dart';
import 'package:interview_portal/presentation/features/auth/provider/auth_provider.dart';

class AuthState {
  final bool loading;
  final String? error;
  final String? token;
  final String? role;

  const AuthState({this.loading = false, this.error, this.token, this.role});

  AuthState copyWith({
    bool? loading,
    String? error,
    String? token,
    String? role,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final usecase = ref.read(loginUseCaseProvider);
      final res = await usecase.call(email, password);

    

      
      final token = res['Token'] ?? res['token'] ?? res['accessToken'] ?? '';
      final role = res['user']?['role'] ?? res['role'] ?? 'user';

      if (token.isEmpty) {
        state = state.copyWith(
          loading: false,
          error: 'Token missing in response',
        );
        return;
      }

      
      await SharedPrefs.saveToken(token);
     

      state = state.copyWith(loading: false, token: token, role: role);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await SharedPrefs.clearToken();
    state = const AuthState();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);
