import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Placeholder()),
  ],
);
