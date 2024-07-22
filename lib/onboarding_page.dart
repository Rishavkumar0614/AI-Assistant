import 'package:flutter/material.dart';
import 'package:ai_assistant/commons.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  int activeSection = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    activeSection = 0;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                      right: 5,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: (activeSection == 0)
                              ? const Color.fromARGB(255, 66, 133, 244)
                              : Colors.white,
                        ),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.ibmPlexSans(fontSize: 20),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    activeSection = 1;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: (activeSection == 1)
                              ? const Color.fromARGB(255, 66, 133, 244)
                              : Colors.white,
                        ),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.ibmPlexSans(fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            if (activeSection == 0)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        prefixIcon: const Icon(Icons.email, size: 20),
                        hintStyle: GoogleFonts.ibmPlexSans(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        prefixIcon: const Icon(Icons.lock, size: 20),
                        hintStyle: GoogleFonts.ibmPlexSans(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 50,
                      width: (MediaQuery.of(context).size.width - 40),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: Color.fromARGB(255, 66, 133, 244),
                      ),
                      child: InkWell(
                        onTap: () => authController.loginUser(
                          _usernameController.text,
                          _passwordController.text,
                          context,
                        ),
                        child: const Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (activeSection == 1)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        prefixIcon: const Icon(Icons.person, size: 20),
                        hintStyle: GoogleFonts.ibmPlexSans(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        prefixIcon: const Icon(Icons.email, size: 20),
                        hintStyle: GoogleFonts.ibmPlexSans(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        prefixIcon: const Icon(Icons.lock, size: 15),
                        hintStyle: GoogleFonts.ibmPlexSans(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 50,
                      width: (MediaQuery.of(context).size.width - 40),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: Color.fromARGB(255, 66, 133, 244),
                      ),
                      child: InkWell(
                        onTap: () => authController.createUser(
                            _usernameController.text,
                            _passwordController.text,
                            _nameController.text,
                            context),
                        child: const Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
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
