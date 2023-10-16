import 'package:flutter/material.dart';
import 'package:jamanacanal/pages/subscription/subscription.dart';
import 'package:jamanacanal/pages/about/about.dart';
import 'package:jamanacanal/pages/bouquet/bouquet_page.dart';
import 'package:jamanacanal/pages/customer/customer.dart';

import '../widgets/app_title.dart';

enum AppPage { home, bouquet, about }

class ApplicationPagesContainer extends StatefulWidget {
  const ApplicationPagesContainer({super.key});

  @override
  State<ApplicationPagesContainer> createState() =>
      _ApplicationPagesContainerState();
}

class _ApplicationPagesContainerState extends State<ApplicationPagesContainer> {
  final _pages = <Widget>[
    const AbonnementPage(),
    const CustomerPage(),
    const BouquetPage(),
    const AboutPage()
  ];

  int _selectedIndex = 0;

  _onItemTapped(int selectedIndex) {
    setState(() {
      _selectedIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppTitle(),
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.now_widgets_rounded),
            label: 'Abonnements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Abonnés',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Bouquets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_sharp),
            label: 'Apropos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
