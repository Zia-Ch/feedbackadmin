import 'package:feedbackadmin/view/screens/questions/questions_screen.dart';
import 'package:feedbackadmin/view/screens/subject/subjects_screen.dart';
import 'package:feedbackadmin/view/screens/teachers/teachers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../batch/batches_screen.dart';
import '../students/students_screen.dart';

class DashBoard extends ConsumerStatefulWidget {
  const DashBoard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashBoardState();
}

class _DashBoardState extends ConsumerState<DashBoard> {
  int _selectedIndex = 0;
  final List<NavigationDestination> destinations = const [
    /*NavigationDestination(
      icon: Icon(Icons.home),
      label: 'FeedBacks',
    ),*/
    NavigationDestination(
      icon: Icon(Icons.question_answer),
      label: 'Questions',
    ),
    NavigationDestination(
      icon: Icon(Icons.person),
      label: 'Batch',
    ),
    NavigationDestination(
      icon: Icon(Icons.person),
      label: 'Teachers',
    ),
    NavigationDestination(
      icon: Icon(Icons.school),
      label: 'Students',
    ),
    NavigationDestination(
      icon: Icon(Icons.book_outlined),
      label: 'Subjects',
    ),
  ];

  final List<Widget> _children = [
    //const Center(child: Text('FeedBacks')),
    const QuestionsScreen(),
    const BatchesScreen(),
    const TeachersScreen(),
    const StudentsScreen(),
    const SubjectssScreen(),
  ];
  void onIndexChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
        selectedIndex: _selectedIndex,
        destinations: destinations,
        onSelectedIndexChange: (index) => onIndexChange(index),
        body: (_) {
          return _children[_selectedIndex];
        });
  }
}
