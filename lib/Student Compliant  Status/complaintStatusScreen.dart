import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompliantStatusScreen extends StatefulWidget {
  const CompliantStatusScreen({super.key});

  @override
  State<CompliantStatusScreen> createState() => _CompliantStatusScreenState();
}

class _CompliantStatusScreenState extends State<CompliantStatusScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // On page load action.
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFCAF0F8),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Check Complaint Status Here 👇',
                        style: GoogleFonts.readexPro(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.pushNamed(context, 'ElectricalStatus');
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFF07BEB8),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Electrical Status',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/electrical.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.pushNamed(context, 'PlumbingStatus');
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8FAB),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 20),
                                  child: Text(
                                    'Plumbing Status',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.readexPro(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 10),
                                  child: Image.asset(
                                    'assets/images/plumbing.png',
                                    width: 71,
                                    height: 72,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.pushNamed(context, 'CarpentryStatus');
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFF70D6FF),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 20),
                                  child: Text(
                                    'Carpentry Status',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 10),
                                  child: Image.asset(
                                    'assets/images/Carpentry.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.pushNamed(context, 'OtherscomStatus');
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC77DFF),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 20),
                                  child: Text(
                                    'Others..',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 10),
                                  child: Image.asset(
                                    'assets/images/application.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}
