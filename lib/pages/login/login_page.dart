import 'package:aldente/bottom_nav_bar.dart';
import 'package:aldente/pages/login/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool ischecked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.3,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/asset1.png"),
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Welcome Back!",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text("Email"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 55,
                    child: TextField(
                      autofocus: false,
                      style: GoogleFonts.poppins(),
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          FontAwesomeIcons.envelope,
                          size: 14,
                        ),
                        prefixIconColor: const Color.fromARGB(255, 18, 147, 252),
                        labelText: "Enter your email",
                        labelStyle: GoogleFonts.poppins(),
                        fillColor: const Color.fromARGB(77, 194, 194, 194),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Password"),
                      Text(
                        "Forgot your password?",
                        style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 55,
                    child: TextField(
                      autofocus: false,
                      style: GoogleFonts.poppins(),
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          FontAwesomeIcons.eye,
                          size: 14,
                        ),
                        prefixIconColor: const Color.fromARGB(255, 18, 147, 252),
                        labelText: "Enter your Password",
                        labelStyle: GoogleFonts.poppins(),
                        fillColor: const Color.fromARGB(77, 194, 194, 194),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: ischecked,
                        activeColor: const Color.fromARGB(255, 18, 53, 252),
                        onChanged: (newBool) {
                          setState(() {
                            ischecked = newBool!;
                          });
                        },
                      ),
                      const Text("Remember me"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Divider(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'or',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.7,
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(77, 196, 190, 190),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                AssetImage("images/google.png"),
                                            filterQuality: FilterQuality.high)),
                                  )
                                ]),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(77, 196, 190, 190),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                              "images/apple.png",
                                            ),
                                            filterQuality: FilterQuality.high)),
                                  )
                                ]),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(77, 196, 190, 190),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                              "images/facebook.png",
                                            ),
                                            filterQuality: FilterQuality.high)),
                                  )
                                ]),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                    GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                      return const BottomNavBar();
                      }));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 10,
                          color: Color.fromARGB(31, 124, 123, 123))
                        ]),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                        "Log in ",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        ),
                        const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                        ),
                      ],
                      ),
                    ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.poppins(
                            color: Colors.black87, fontSize: 10),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const SignUpPage();
                          }));
                        },
                        child: Text(
                          "Sign up now!",
                          style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 14, 64, 230),
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
