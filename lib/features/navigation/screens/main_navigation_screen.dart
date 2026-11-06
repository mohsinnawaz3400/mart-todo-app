import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/screens/home_screen.dart';
import '../../setting/screens/settings_screen.dart';
import '../../statistics/screens/statistics_screen.dart';
import '../../tasks/controllers/task_controller.dart';
import '../../tasks/screens/add_task_screen.dart';
import '../../tasks/screens/all_tasks_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    HomeScreen(
      onViewAll: () {
        _onItemTapped(1);
      },
    ),
    const AllTasksScreen(),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _onAddTap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (!mounted) return;

    await context.read<TaskController>().loadTasks();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TaskController>().loadTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,

        onTap: _onItemTapped,

        onAddTap: _onAddTap,
      ),
    );
  }
}
