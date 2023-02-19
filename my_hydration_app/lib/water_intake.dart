import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterIntake extends StatefulWidget {
  const WaterIntake({super.key});

  @override
  _WaterIntakeState createState() => _WaterIntakeState();
}

class _WaterIntakeState extends State<WaterIntake> {
  final _waterIntakeController = TextEditingController();
  int _waterIntake = 0;
  int _hydrationGoal = 2000;

  Future<void> _loadHydrationGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final hydrationGoal = prefs.getInt('hydrationGoal') ?? 2000;
    setState(() {
      _hydrationGoal = hydrationGoal;
    });
  }

  Future<void> _saveHydrationGoal(int hydrationGoal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('hydrationGoal', hydrationGoal);
  }

  @override
  void initState() {
    super.initState();
    _loadWaterIntake();
    _loadHydrationGoal();
  }

  Future<void> _loadWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    final waterIntake = prefs.getInt('waterIntake') ?? 0;
    setState(() {
      _waterIntake = waterIntake;
    });
  }

  Future<void> _saveWaterIntake(int waterIntake) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterIntake', waterIntake);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Water Intake',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _waterIntakeController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'How much water did you drink?',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final waterIntake = int.tryParse(_waterIntakeController.text) ?? 0;
            await _saveWaterIntake(_waterIntake + waterIntake);
            setState(() {
              _waterIntake += waterIntake;
              _waterIntakeController.clear();
            });
          },
          child: const Text('Save'),
        ),
        const SizedBox(height: 16),
        Text(
          'Total Water Intake: $_waterIntake ml',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Daily Goal: $_hydrationGoal ml',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                 final hydrationGoal = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('Set Daily Hydration Goal'),
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter your goal in ml',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(
                                    context,
                                    _waterIntakeController.text,
                                  ),
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ) ??
                    '2000';

                await _saveHydrationGoal(int.parse(hydrationGoal));
                setState(() {
                  _hydrationGoal = int.parse(hydrationGoal);
                });
              },
              child: const Text('Set Goal'),
            ),
          ],
        ),
      ],
    );
  }
}
