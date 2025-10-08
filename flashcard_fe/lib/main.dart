import 'package:flashcard_fe/app.dart';
import 'package:flashcard_fe/src/features/auth/presentation/bloc/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlocProvider(create: (_) => LoginBloc(), child: const App()));
}
