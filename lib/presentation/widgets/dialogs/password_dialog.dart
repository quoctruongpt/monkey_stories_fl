import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/presentation/bloc/debug/debug_cubit.dart';
import 'package:monkey_stories/domain/usecases/remote_config/get_pass_debug.dart';

Future<void> showPasswordDialog({required BuildContext context}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return const PasswordDialog();
    },
    barrierDismissible: false,
  );
}

enum VerificationState { pending, success, failure }

class PasswordDialog extends StatefulWidget {
  const PasswordDialog({super.key});

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final _passwordController = TextEditingController();
  String _passDebug = '';
  var _verificationState = VerificationState.pending;

  Future<void> _getPassDebug() async {
    final result = await sl<GetPassDebugUsecase>().call(NoParams());
    result.fold((failure) {}, (password) => _passDebug = password);
  }

  @override
  void initState() {
    super.initState();
    _getPassDebug();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _verifyPassword() {
    if (_passwordController.text == _passDebug && _passDebug.isNotEmpty) {
      context.read<DebugCubit>().toggleModeDebug();
      setState(() {
        _verificationState = VerificationState.success;
      });
    } else {
      setState(() {
        _verificationState = VerificationState.failure;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_verificationState) {
      case VerificationState.success:
        return AlertDialog(
          title: const Text('Cửa đã mở!'),
          content: const Text(
            'Vừng đã mở, cửa hang hé lộ,\n'
            'Kho báu này chỉ của riêng ta.\n'
            'Xin giữ bí mật những điều sắp tỏ,\n'
            'Chớ để lọt ra thế giới ngoài xa.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tuyệt vời!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      case VerificationState.failure:
        return AlertDialog(
          title: const Text('Sai mật khẩu!'),
          content: const Text(
            'Thần chú sai rồi, cửa chẳng ran,\n'
            'Báu vật còn nguyên, chốn an toàn.\n'
            'Muốn biết mật khẩu, chớ lan man,\n'
            'Hỏi người kỹ thuật, hết than van.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Thử lại'),
              onPressed: () {
                setState(() {
                  _passwordController.clear();
                  _verificationState = VerificationState.pending;
                });
              },
            ),
          ],
        );
      case VerificationState.pending:
        return AlertDialog(
          title: const Text('Vừng ơi mở cửa ra'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('\'Pig\' 🐷 dịch sang tiếng Việt là gì?'),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'PTL 2k'),
                autofocus: true,
                onSubmitted: (_) => _verifyPassword(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Huỷ'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(child: const Text('OK'), onPressed: _verifyPassword),
          ],
        );
    }
  }
}
