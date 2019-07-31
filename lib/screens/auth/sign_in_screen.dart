import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/constants.dart';

/// Represents the sign in landing screen.
class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  FocusNode emailNode;
  FocusNode passwordNode;

  @override
  void initState() {
    emailNode = FocusNode();
    passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account / Sign In'),
      ),
      body: GestureDetector(
        onTap: () {
          if (emailNode.hasFocus) {
            emailNode.unfocus();
          }
          if (passwordNode.hasFocus) {
            passwordNode.unfocus();
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
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
                        TextField(
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: emailNode,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'user@example.com',
                            // errorText: 'TODO: use bloc',
                          ),
                          onSubmitted: (String text) {
                            emailNode.nextFocus();
                          },
                          onChanged: (String text) => print('TODO: use bloc'),
                        ),

                        // Password field
                        TextField(
                          autocorrect: false,
                          obscureText: true,
                          textInputAction: TextInputAction.go,
                          focusNode: passwordNode,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'password',
                            // errorText: 'TODO: use bloc',
                          ),
                          onSubmitted: (String text) {
                            passwordNode.unfocus();
                          },
                          onChanged: (String text) => print('TODO: use bloc'),
                        ),

                        const SizedBox(height: 24.0),

                        // Sign In button
                        Container(
                          width: double.infinity,
                          height: 40.0,
                          child: RaisedButton(
                            child: const Text('Sign In'),
                            onPressed: () => print('TODO: use bloc'),
                          ),
                        ),

                        const SizedBox(height: 8.0),

                        // Create Account / Forgot Password
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => print('TODO: implement'),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () => print('TODO: implement'),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24.0),

                        // Login with Facebook button
                        FlatButton(
                          child: Image.asset('assets/images/continue_with_facebook.png'),
                          onPressed: () => print('TODO: implement'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
