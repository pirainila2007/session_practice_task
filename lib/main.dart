
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Session App',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorSchemeSeed: const Color(0xFF5B7CFA),
      ),
      home: const SessionPage(),
    );
  }
}

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController ageController =
      TextEditingController();

  late final ConfettiController _confettiController;

  int count = 10;

  final List<Map<String, dynamic>> savedRecords = [];

  final Color primaryBlue = const Color(0xFF397BFA);
  final Color darkBlue = const Color(0xFF142D78);
  final Color lavender = const Color(0xFFEDE7FF);

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  void increaseCount() {
    setState(() {
      count++;
    });
  }

  void decreaseCount() {
    if (count > 0) {
      setState(() {
        count--;
      });
    }
  }

  void saveData() {
    final String name = nameController.text.trim();
    final String ageText = ageController.text.trim();

    if (name.isEmpty || ageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name and age!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final int? age = int.tryParse(ageText);

    if (age == null || age <= 0 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid age!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      savedRecords.add({
        'name': name,
        'age': age,
        'count': count,
      });
    });

    // 🎉 Play confetti after successfully saving
    _confettiController.play();

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Your details saved successfully! 💙🎉',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF397BFA),
      ),
    );
  }

  void refreshForm() {
    setState(() {
      nameController.clear();
      ageController.clear();
      count = 10;
    });

    FocusScope.of(context).unfocus();
  }

  void deleteRecord(int index) {
    setState(() {
      savedRecords.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Record deleted successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Widget sectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFFE2EBFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: darkBlue, size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: darkBlue,
          ),
        ),
      ],
    );
  }

  Widget buildInput({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 43,
              width: 43,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isNumber
                      ? [
                          const Color(0xFFFFD8E9),
                          const Color(0xFFFFEAF3),
                        ]
                      : [
                          const Color(0xFFD9EAFF),
                          const Color(0xFFE8E6FF),
                        ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isNumber
                    ? const Color(0xFFE65D91)
                    : const Color(0xFF5366D9),
                size: 23,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: isNumber
              ? TextInputType.number
              : TextInputType.name,
          inputFormatters: isNumber
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          textCapitalization: isNumber
              ? TextCapitalization.none
              : TextCapitalization.words,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF929BB5),
              fontSize: 15,
            ),
            filled: true,
            fillColor: const Color(0xFFFCFCFF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color(0xFFBDD4FF),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: primaryBlue,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCountCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE4E9FF),
            Color(0xFFFFEDF5),
            Color(0xFFDFF0FF),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          Text(
            '✦  Count  ✦',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              countButton(
                icon: Icons.remove,
                colors: const [
                  Color(0xFFFF9EAF),
                  Color(0xFFFF6685),
                ],
                onTap: decreaseCount,
              ),
              const SizedBox(width: 24),
              Container(
                constraints: const BoxConstraints(minWidth: 100),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF202A48),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              countButton(
                icon: Icons.add,
                colors: const [
                  Color(0xFF7ADBC0),
                  Color(0xFF32B99D),
                ],
                onTap: increaseCount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget countButton({
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors.last.withValues(alpha: 0.23),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF52A6FF),
            Color(0xFF397BFA),
            Color(0xFF5965F5),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.27),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: saveData,
        icon: const Icon(Icons.save_rounded, size: 27),
        label: const Text(
          'Save',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget buildRecordCard(
    int index,
    Map<String, dynamic> record,
  ) {
    final List<Color> accentColors = [
      const Color(0xFF7CCBFF),
      const Color(0xFFAE8BFF),
      const Color(0xFFFF8FBD),
      const Color(0xFF73DCC2),
    ];

    final Color accent =
        accentColors[index % accentColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border(
          left: BorderSide(color: accent, width: 6),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B96D8)
                .withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 16,
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: darkBlue,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  recordLine('Name', '${record['name']}'),
                  const SizedBox(height: 7),
                  recordLine('Age', '${record['age']}'),
                  const SizedBox(height: 7),
                  recordLine('Count', '${record['count']}'),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Delete record',
              onPressed: () => deleteRecord(index),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFFFE8EF),
              ),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFFF6387),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recordLine(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 58,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: Color(0xFF69799F),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Welcome to your Session App! 💜'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(
            Icons.menu_rounded,
            color: Color(0xFF4E4AD7),
            size: 29,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Session',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: Color(0xFF142D78),
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.favorite_border_rounded,
              color: Color(0xFFFF79AC),
              size: 24,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: refreshForm,
            tooltip: 'Refresh form',
            icon: const Icon(
              Icons.refresh_rounded,
              size: 29,
              color: Color(0xFF4E4AD7),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),

      // 🎉 Stack displays confetti over the existing screen.
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF1F5FF),
                  Color(0xFFFFF5FA),
                  Color(0xFFF2F0FF),
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20, 20, 20, 30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    // Dance image and welcome section
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Dance\nMakes Life\nBetter ♡',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    height: 1.5,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5155B8),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFD8DFFF),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue
                                          .withValues(alpha: 0.12),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/dance_pose.png',
                                    width: 145,
                                    height: 145,
                                    fit: BoxFit.cover,
                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return Container(
                                        width: 145,
                                        height: 145,
                                        color: lavender,
                                        child: const Icon(
                                          Icons.nightlife_rounded,
                                          size: 65,
                                          color: Color(0xFF6A61D9),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Keep\nGoing ♡',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    height: 1.5,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5155B8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Dream it. Dance it. Live it. ✨',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF777BC8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Name and age card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8499CF)
                                .withValues(alpha: 0.14),
                            blurRadius: 22,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          buildInput(
                            label: 'Name',
                            hint: 'Enter your name',
                            icon: Icons.person_rounded,
                            controller: nameController,
                          ),
                          const SizedBox(height: 25),
                          buildInput(
                            label: 'Age',
                            hint: 'Enter your age',
                            icon: Icons.cake_rounded,
                            controller: ageController,
                            isNumber: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Count
                    buildCountCard(),

                    const SizedBox(height: 22),

                    // Save button
                    buildSaveButton(),

                    const SizedBox(height: 30),

                    // Saved details title
                    sectionLabel(
                      'Saved Details',
                      Icons.view_agenda_rounded,
                    ),

                    const SizedBox(height: 17),

                    // Saved records
                    if (savedRecords.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFFE2E4FF),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.favorite_rounded,
                              size: 35,
                              color: Color(0xFFB5A7FF),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No data saved yet.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF626FA1),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Your records will appear here ♡',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9BA5C3),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...savedRecords.asMap().entries.map(
                        (entry) {
                          return buildRecordCard(
                            entry.key,
                            entry.value,
                          );
                        },
                      ),

                    const SizedBox(height: 12),

                    // Footer
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFEDE7FF),
                            Color(0xFFFFEAF4),
                            Color(0xFFE1F0FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Color(0xFF6674DF),
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              'Small Steps, Big Dreams ✨',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5559B6),
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

          // 🎉 Confetti overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality:
                      BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 35,
                  emissionFrequency: 0.05,
                  gravity: 0.20,
                  maxBlastForce: 25,
                  minBlastForce: 10,
                  colors: const [
                    Color(0xFF397BFA),
                    Color(0xFFFF79AC),
                    Color(0xFFAE8BFF),
                    Color(0xFF73DCC2),
                    Color(0xFFFFD166),
                    Color(0xFF52A6FF),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

