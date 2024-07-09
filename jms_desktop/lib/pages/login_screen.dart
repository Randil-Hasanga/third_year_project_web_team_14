import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:jms_desktop/services/firebase_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _email, _password;
  FirebaseService? _firebaseService;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/images/man.png',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _loginForm(),
                    _loginButton(),
                    const SizedBox(height: 10.0),
                    TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: Text('Forgot Password?'))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          _userNameTextField(),
          const SizedBox(height: 20.0),
          _paswordTextField(),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _userNameTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          hintText: 'Email',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.person),
        ),
        onSaved: (_newValue) {
          setState(() {
            _email = _newValue;
          });
        },
        validator: (_value) {
          bool _result = _value!.contains(
            RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
          );
          return _result ? null : "Please enter a valid email";
        },
        onFieldSubmitted: (_) => _loginUser(),
      ),
    );
  }

  Widget _paswordTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: _passwordController,
        decoration: const InputDecoration(
          hintText: 'Password',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.lock),
        ),
        onSaved: (_newValue) {
          setState(() {
            _password = _newValue;
          });
        },
        validator: (_value) => _value!.length >= 8
            ? null
            : "Please enter password greater than 8 characters",
        obscureText: true,
        onFieldSubmitted: (_) => _loginUser(),
      ),
    );
  }

  Widget _loginButton() {
    return MaterialButton(
      onPressed: _isLoading ? null : _loginUser,
      height: 50,
      color: Colors.orange[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            )
          : const Text(
              "Login",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
    );
  }

  void _loginUser() async {
    setState(
      () {
        _isLoading = true; // Set to true when login starts
      },
    );
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      bool _result = await _firebaseService!.loginUser(
          email: _emailController.text, password: _passwordController.text);

      setState(
        () {
          _isLoading = false; // Set to false when login ends
        },
      );

      if (_result) {
        if (_firebaseService!.currentUser!['type'] == 'officer') {
          Navigator.popAndPushNamed(context, '/MainPage');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Invalid email or password",
                selectionColor: Color.fromARGB(255, 230, 255, 2),
              ),
            ),
          );
        }
        setState(
          () {
            _isLoading = false; // Set to false when login ends
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Invalid email or password",
              textAlign: TextAlign.center,
              selectionColor: Color.fromARGB(255, 230, 255, 2),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Invalid Email",
            textAlign: TextAlign.center,
            selectionColor: Color.fromARGB(255, 230, 255, 2),
          ),
        ),
      );
      setState(
        () {
          _isLoading = false; // Set to false when login ends
        },
      );
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Enter your email',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _sendPasswordResetEmail,
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent')),
      );
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
