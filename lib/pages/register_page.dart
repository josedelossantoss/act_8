import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../appbar.dart';
import '../input.dart';
import '../scrollable_column.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage() : super();
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  bool _agreeWithTermsAndConditions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMART INICIA SESION'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        leading: Icon(
          Icons.menu,
          color: Colors.blue,
        ),
      ),
      body: Container(
        color: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Form(
          key: _formKey,
          child: ScrollableColumn(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                child: TextField(
                  decoration: InputDecoration(
                    label: Text('NOMBRE'),
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                child: TextField(
                  decoration: InputDecoration(
                    label: Text('APELLIDO'),
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                child: TextField(
                  decoration: InputDecoration(
                    label: Text('CORREO'),
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                  ),
                ),
              ),
              CustomInputField(
                keyboardType: TextInputType.emailAddress,
                hintText: "CONFIRMAR CORREO",
                controller: _emailController,
                validator: (String? email) {
                  if (email == null) {
                    return null;
                  }
                  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                  return emailValid ? null : "Email is not valid";
                },
              ),
              SizedBox(height: 24),
              CustomInputField(
                keyboardType: TextInputType.visiblePassword,
                hintText: "Contraseña",
                obscureText: true,
                controller: _passwordController,
                validator: (String? password) {
                  if (password == null) {
                    return null;
                  }
                  if (password.length < 6) {
                    return "Muy corta";
                  }
                },
              ),
              SizedBox(height: 24),
              CustomInputField(
                keyboardType: TextInputType.visiblePassword,
                hintText: "CONFIRMAR CONTRASENA",
                obscureText: true,
                controller: _passwordConfirmationController,
                validator: (String? password) {
                  if (password == null) {
                    return null;
                  }
                  if (password != _passwordConfirmationController.value.text) {
                    return "No confirmada";
                  }
                },
              ),
              SizedBox(height: 24),
              CustomCheckbox(
                label: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "Acepto los TERMINOS",
                        style: TextStyle(
                          color: Color(0xFFa8a8a7),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text('Terminos y condiciones'),
                      onPressed: () {
                        print("// Terms & Conditions");
                      },
                    ),
                  ],
                ),
                value: _agreeWithTermsAndConditions,
                onChanged: (checked) => setState(() => _agreeWithTermsAndConditions = checked ?? false),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  "REGISTER",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: !_agreeWithTermsAndConditions
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: _emailController.value.text,
                            password: _passwordController.value.text,
                          )
                              .then((result) {
                            Navigator.of(context).pushNamedAndRemoveUntil('/main', (_) => false);
                          }).catchError((Object exception) {
                            if (exception is FirebaseAuthException) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to register: ${exception.message}')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Unhandled register error ${exception}')),
                              );
                            }
                          });
                        }
                      },
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushNamed("/login")
                    },
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
