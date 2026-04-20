import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/model/known_person.dart';
import 'package:lifelinker/provider/add_person.dart';
import 'package:lifelinker/provider/edit_person.dart';
import 'package:lifelinker/view/edit%20person/components/face_tab.dart';
import 'package:lifelinker/view/edit%20person/components/header.dart';
import 'package:lifelinker/view/edit%20person/components/info.dart';
import 'package:lifelinker/view/edit%20person/components/tab_bar.dart';
import 'package:provider/provider.dart';

class EditPersonView extends StatefulWidget {
  final KnownPerson person;
  const EditPersonView({super.key, required this.person});

  @override
  State<EditPersonView> createState() => _EditPersonViewState();
}

class _EditPersonViewState extends State<EditPersonView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

@override
void initState() {
  super.initState();
  _tabController = TabController(length: 2, vsync: this);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<EditPersonProvider>().initPerson(widget.person);
  });
}
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
     context.read<AddPersonProvider>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditPersonProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundAlt,
          body: Column(
            children: [
              EditPersonHeader(
                onBack: () => Navigator.pop(context, provider.isFormDirty),
              ),
              EditPersonTabBar(tabController: _tabController),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    EditPersonInfoTab(tabController: _tabController),
                    const EditPersonFaceTab(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
