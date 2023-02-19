import 'package:flutter/material.dart';
import 'package:my_hydration_app/water_intake.dart';
import 'package:my_hydration_app/workout_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Fitness Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _currentIndex = ValueNotifier<int>(0);
  final List<Widget> _tabs = [
    const WorkoutTimer(),
    const WaterIntake(),
  ];

  Future<void> _reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _currentIndex,
        builder: (context, index, child) => _tabs[index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex.value,
        onTap: (index) => _currentIndex.value = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Workout Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: 'Water Intake',
          ),
        ],
      ),
    );
  }
}




//original one below

// import 'package:flutter/material.dart';
// import 'package:my_hydration_app/water_intake.dart';

// import 'journal.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Journal App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Journal App'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Journal'),
//               Tab(text: 'Water Intake'),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             Journal(),
//             WaterIntake(),
//           ],
//         ),
//       ),
//     );
//   }
// }


//this is the second part code
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'water_intake.dart';
// import 'journal.dart'; // import the Journal widget

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;

//   final List<Widget> _children = [
//     WaterIntake(),
//     Journal(), // add the Journal widget to the list of children
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Health Tracker'),
//       ),
//       body: _children[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: onTabTapped,
//         currentIndex: _currentIndex,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.local_drink),
//             label: 'Water',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'Journal',
//           ),
//         ],
//       ),
//     );
//   }

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
// }


      
          // body: Container(
          //   padding: EdgeInsets.symmetric(horizontal: 16),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       SizedBox(height: 16),
          //       Text(
          //         'Water Intake',
          //         style: TextStyle(
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       SizedBox(height: 16),
          //       TextField(
          //         decoration: InputDecoration(
          //           border: OutlineInputBorder(),
          //           labelText: 'How much water did you drink?',
          //         ),
          //       ),
          //       SizedBox(height: 16),
          //       ElevatedButton(
          //         onPressed: () {},
          //         child: Text('Save'),
          //       ),
          //       SizedBox(height: 32),
          //       Text(
          //         'Hydration Goals',
          //         style: TextStyle(
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       SizedBox(height: 16),
          //       TextField(
          //         decoration: InputDecoration(
          //           border: OutlineInputBorder(),
          //           labelText: 'How much water do you want to drink per day?',
          //         ),
          //       ),
          //       SizedBox(height: 16),
          //       ElevatedButton(
          //         onPressed: () {},
          //         child: Text('Save'),
          //       ),
          //     ],
          //   ),
          // ),