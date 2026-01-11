import 'package:bolt/features/auth/data/auth_repository.dart';
import 'package:bolt/features/auth/presentation/auth_controller.dart';
import 'package:bolt/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.authCode});

  final String? authCode;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.authCode != null) {
      print('LoginScreen initialized with authCode: ${widget.authCode}');
      // Schedule the login call after the first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('Triggering login in AuthController');
        ref.read(authControllerProvider.notifier).login(widget.authCode!);
      });
    } else {
      print('LoginScreen initialized without authCode');
    }
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.authCode != oldWidget.authCode && widget.authCode != null) {
      print('LoginScreen updated with authCode: ${widget.authCode}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('Triggering login in AuthController (didUpdateWidget)');
        ref.read(authControllerProvider.notifier).login(widget.authCode!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flash_on, size: 80, color: Color(0xFFFFD700)),
            const SizedBox(height: 20),
            Text(
              l10n.appTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            authState.when(
              data: (state) {
                // TODO: Use 'is AuthStateUnauthenticated' or 'map' once static analysis visibility issue is resolved.
                final type = state.runtimeType.toString();
                if (type == 'AuthStateUnauthenticated') {
                  return ElevatedButton(
                    onPressed: () async {
                      final repo = ref.read(authRepositoryProvider);
                      final url = repo.getAuthorizationUrl();
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.msgLaunchAuthUrlFailed),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: Text(l10n.btnConnectNotion),
                  );
                } else if (type == 'AuthStateError') {
                  final message = (state as dynamic).message;
                  return Column(
                    children: [
                      Text(l10n.msgError(message.toString())),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final repo = ref.read(authRepositoryProvider);
                          final url = repo.getAuthorizationUrl();
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: Text(l10n.btnRetry),
                      ),
                    ],
                  );
                }
                return const CircularProgressIndicator();
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Column(
                children: [
                  Text(l10n.msgError(e.toString())),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final repo = ref.read(authRepositoryProvider);
                      final url = repo.getAuthorizationUrl();
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: Text(l10n.btnRetry),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
