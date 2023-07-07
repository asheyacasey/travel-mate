import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/repositories/auth/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;


part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  Future<void> signupWithCredentials(BuildContext context) async {
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;
    emit(
      state.copyWith(status: SignupStatus.submitting),
    );
    try {
      var user = await _authRepository.signUp(
          email: state.email, password: state.password);
      emit(
        state.copyWith(
          status: SignupStatus.success,
          user: user,
        ),
      );
    } on auth.FirebaseAuthException catch (e) {
      print(e.message);
      emit(
        state.copyWith(
          status: SignupStatus.error,
        ),
      );
    }
  }
}
