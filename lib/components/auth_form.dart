import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/errors/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { sigup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  AuthMode _authMode = AuthMode.login;
  bool _isLoading = false;

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSigup() => _authMode == AuthMode.sigup;

  void _swithAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.sigup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;
        _controller?.reverse();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));

    _slideAnimation = Tween(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    void showErrorDialog(String msg) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Ocorreu um erro'),
                content: Text(msg),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Fechar'),
                  ),
                ],
              ));
    }

    void submit() async {
      final isValid = _formKey.currentState!.validate();

      if (!isValid) {
        return;
      }

      setState(() => _isLoading = true);

      _formKey.currentState?.save();
      Auth auth = Provider.of(context, listen: false);

      try {
        if (_isLogin()) {
          // Logar
          await auth.login(
            _authData['email']!,
            _authData['password']!,
          );
        } else {
          // Registrar
          await auth.singup(
            _authData['email']!,
            _authData['password']!,
          );
        }
      } on AuthException catch (err) {
        showErrorDialog(err.toString());
      } catch (err) {
        showErrorDialog('Erro desconhecido');
      }

      setState(() => _isLoading = false);
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 310 : 400,
        width: deviceSize.width * .75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (em) {
                  final email = em ?? '';

                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um Email válido';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (pw) {
                  final password = pw ?? '';

                  if (password.isEmpty || password.length < 5) {
                    return 'Senha deve ter pelo menos 5 caracteres';
                  }
                  return null;
                },
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isSigup() ? 60 : 0,
                  maxHeight: _isSigup() ? 120 : 0,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Confirmar Senha'),
                      onFieldSubmitted: (_) => submit(),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      validator: _isLogin()
                          ? null
                          : (cPassword) {
                              final confirmPassword = cPassword ?? '';

                              if (confirmPassword != _passwordController.text) {
                                return 'Senhas não conferem iguais';
                              }
                              return null;
                            },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR-SE',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
              Spacer(),
              TextButton(
                onPressed: _swithAuthMode,
                child: Text(
                  _isLogin() ? 'DESEJA SE REGISTRAR?' : 'JÁ POSSIU CONTA?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
