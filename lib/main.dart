import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BellyMeterApp());
}
class NameEntryPage extends StatefulWidget {
  const NameEntryPage({super.key});

  @override
  State<NameEntryPage> createState() => _NameEntryPageState();
}

class _NameEntryPageState extends State<NameEntryPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Your Name')),
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/background.png',
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'What’s your name?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your name',
                  fillColor: Colors.white70,
                  filled: true,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  final name = _nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a name')),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(childName: name),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}


class AnimatedWaveClipper extends CustomClipper<Path> {
  final double waveOffset;

  AnimatedWaveClipper(this.waveOffset);

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 10);

    path.quadraticBezierTo(
      size.width * 0.25 + waveOffset,
      0,
      size.width * 0.5 + waveOffset,
      10,
    );
    path.quadraticBezierTo(
      size.width * 0.75 + waveOffset,
      20,
      size.width + waveOffset,
      10,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant AnimatedWaveClipper oldClipper) {
    return oldClipper.waveOffset != waveOffset;
  }
}


class BellyMeterApp extends StatelessWidget {
  const BellyMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belly Meter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
home: NameEntryPage(),

    );
  }
}

class HomePage extends StatefulWidget {
  final String childName;

  const HomePage({super.key, required this.childName});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  String selectedAvatar = 'assets/images/tummy.png';
final List<String> avatarPaths = [
  'assets/images/boy.png',
  'assets/images/girl.png',
  'assets/images/dino.png',
  'assets/images/Ptera.png',
  'assets/images/Unicorn.png',
  'assets/images/Red Panda.png',
  'assets/images/Panda.png',
  'assets/images/Lion.png',
  'assets/images/Dragon.png',
  'assets/images/Lemur.png',
  'assets/images/Dog.png',
  'assets/images/Cat.png',
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Avatar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Choose an Avatar:'),
            const SizedBox(height: 10),
Expanded(
  child: PageView(
    onPageChanged: (index) {
      setState(() {
        selectedAvatar = avatarPaths[index];
      });
    },
    children: avatarPaths.map((path) {
      return GestureDetector(
        onTap: () {
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BellyHomePage(
      childName: widget.childName, // ✅ NOT hardcoded or missing
      avatarPath: path,
    ),
  ),
);

        },
child: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Center(
    child: Image.asset(
      path,
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.5,
    ),
  ),
),

      );
    }).toList(),
  ),
),
          ],
        ),
      ),
    );
  }

  Widget avatarChoice(String path) {
    return GestureDetector(
onTap: () {
  setState(() {
    selectedAvatar = path;
  });

onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BellyHomePage(
        childName: widget.childName,
        avatarPath: path,
      ),
    ),
  );
};
},

      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedAvatar == path ? Colors.blue : Colors.grey,
            width: 3,
          ),
        ),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class BellyHomePage extends StatefulWidget {
  final String childName;
  final String avatarPath;

  const BellyHomePage({super.key, required this.childName, required this.avatarPath});

  @override
  State<BellyHomePage> createState() => _BellyHomePageState();
}

class _BellyHomePageState extends State<BellyHomePage> with TickerProviderStateMixin {
  double bellyFullness = 0.0;
  double targetFullness = 0.0;
  double _parentSelectedFullness = 50.0; // default mid value
  bool isScanning = false;
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _waveController;
late Animation<double> _waveAnimation;

  bool showHappyFace = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
      print('BellyHomePage received child name: ${widget.childName}');
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _waveController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 900),
)..repeat();

_waveAnimation = Tween<double>(begin: 0, end: 20).animate(_waveController);

  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
    _waveController.dispose();

  }

  void playSound(String filename) async {
    await _audioPlayer.play(AssetSource(filename));
  }

  void startScanning(double fullness) async {
    setState(() {
      isScanning = true;
      targetFullness = fullness.clamp(0, 100);
    });

    playSound('sounds/scan.mp3');

    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      isScanning = false;
      bellyFullness = targetFullness;

      if (bellyFullness == 100) {
        _confettiController.play();
        playSound('sounds/ding.mp3');
        showHappyFace = true;
      } else {
        showHappyFace = false;
      }
    });
  }

void showParentInputDialog() {
  _parentSelectedFullness = bellyFullness; // start slider from current value

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Parent Input'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fullness: ${_parentSelectedFullness.toInt()}%',
                  style: const TextStyle(fontSize: 18),
                ),
                Slider(
                  value: _parentSelectedFullness,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: '${_parentSelectedFullness.toInt()}%',
                  onChanged: (value) {
                    setState(() {
                      _parentSelectedFullness = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  startScanning(_parentSelectedFullness);
                },
                child: const Text('Start Scan'),
              ),
            ],
          );
        },
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belly Meter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
Text(
  '${widget.childName}\'s Belly 🍔',
  style: GoogleFonts.fredoka(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple,
  ),
),


            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(0, 0.3),
                    child: SizedBox(
                      width: 500,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
Align(
  alignment: Alignment.bottomCenter,
  child: SizedBox(
    height: 220,
    width: 500,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: bellyFullness / 100,
            child: AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return ClipPath(
                  clipper: AnimatedWaveClipper(_waveAnimation.value),
                  child: Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/tummyfill.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  ),
),



                        ],
                      ),
                    ),
                  ),
Positioned.fill(
  child: isScanning
      ? Container(
          color: Colors.black, // optional background
          child: Image.asset(
            'assets/images/scan.gif',
            fit: BoxFit.contain,
          ),
        )
      : Image.asset(widget.avatarPath, fit: BoxFit.cover),
),

                  if (showHappyFace)
  Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: const Text(
          'Good Job!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    ),
  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      colors: const [
                        Colors.green,
                        Colors.blue,
                        Colors.pink,
                        Colors.orange,
                        Colors.purple,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orangeAccent,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
    textStyle: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
    elevation: 8,
  ),
  onPressed: showParentInputDialog,
  child: const Text('Ready to Scan!'),
),


          ],
        ),
      ),
    );
  }
}
