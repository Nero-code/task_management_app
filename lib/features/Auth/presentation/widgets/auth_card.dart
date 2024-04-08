import 'package:flutter/material.dart';

class AuthCard extends StatefulWidget {
  AuthCard(
      {super.key,
      required this.buttonLabel,
      required this.onPressed,
      required this.onChangeType,
      required this.changeAuthTitle});

  final String buttonLabel, changeAuthTitle;
  final void Function(String email, String pass) onPressed;
  final VoidCallback onChangeType;

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          // color: const Color.fromARGB(255, 238, 238, 238),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  label: Text("Email"),
                  hintText: "for seccess path try \"eve.holt@reqres.in\"",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passCtrl,
                obscureText: isHidden,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  label: Text("Password"),
                  hintText: "123456789",
                  border: OutlineInputBorder(),
                  suffix: SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      splashRadius: 25,
                      onPressed: () {
                        setState(() {
                          isHidden = !isHidden;
                        });
                      },
                      icon: Icon(
                        isHidden ? Icons.visibility_off : Icons.visibility,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onPressed(emailCtrl.text, passCtrl.text);
                  }
                },
                child: Text(widget.buttonLabel),
              ),
              SizedBox(height: 50),
              TextButton(
                onPressed: widget.onChangeType,
                child: Text(
                  widget.changeAuthTitle,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
