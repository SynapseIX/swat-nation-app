import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/blocs/auth_screens_bloc.dart';
import 'package:swat_nation/constants.dart';

/// Represents the create account screen.
class CreateAccountScreen extends StatefulWidget {
  @override
  State createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  FocusNode emailNode;
  FocusNode passwordNode;
  FocusNode confirmPasswordNode;

  @override
  void initState() {
    emailNode = FocusNode();
    passwordNode = FocusNode();
    confirmPasswordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthScreensBloc bloc = AuthScreensBloc();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: GestureDetector(
        onTap: () => _dismissKeyboard(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // Logo
                    Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF333333),
                        shape: BoxShape.circle,
                      ),
                      child: Hero(
                        tag: 'swat_nation_logo',
                        child: CachedNetworkImage(
                          imageUrl: kLogo,
                          fadeInDuration: Duration(milliseconds: 300),
                          width: 120.0,
                          height: 120.0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    // Email field
                    StreamBuilder<String>(
                      stream: bloc.emailStream,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return TextField(
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: emailNode,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'user@example.com',
                            errorText: snapshot.error,
                          ),
                          onSubmitted: (String text) {
                            emailNode.nextFocus();
                          },
                          onChanged: bloc.onChangeEmail,
                        );
                      },
                    ),

                    // Password field
                    StreamBuilder<String>(
                      stream: bloc.passwordStream,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return TextField(
                          autocorrect: false,
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          focusNode: passwordNode,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'password',
                            errorText: snapshot.error,
                          ),
                          onSubmitted: (String text) {
                            passwordNode.nextFocus();
                          },
                          onChanged: bloc.onChangePassword,
                        );
                      },
                    ),

                    // Confirm password field
                    StreamBuilder<String>(
                      stream: bloc.confirmPasswordStream,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return TextField(
                          autocorrect: false,
                          obscureText: true,
                          textInputAction: TextInputAction.go,
                          focusNode: confirmPasswordNode,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'confirm password',
                            errorText: snapshot.error,
                          ),
                          onSubmitted: (String text) {
                            confirmPasswordNode.unfocus();
                          },
                          onChanged: bloc.onChangeConfirmPassword,
                        );
                      },
                    ),

                    const SizedBox(height: 24.0),

                    // Create Account button
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      child: StreamBuilder<bool>(
                        stream: bloc.createAccountValidStream,
                        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                          return RaisedButton(
                            child: const Text('Create Account'),
                            onPressed: snapshot.hasData
                              ? () {
                                print('TODO: Register user on Firebase');
                                print('Email: ${bloc.emailValue}');
                                print('Password: ${bloc.passwordValue}');
                                _dismissKeyboard();
                              }
                              : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _dismissKeyboard() {
    if (emailNode.hasFocus) {
      emailNode.unfocus();
    }

    if (passwordNode.hasFocus) {
      passwordNode.unfocus();
    }

    if (confirmPasswordNode.hasFocus) {
      confirmPasswordNode.unfocus();
    }
  }
}
