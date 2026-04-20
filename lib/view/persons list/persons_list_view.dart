import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/custom_confirm_dialog.dart';
import 'package:lifelinker/model/known_person.dart';
import 'package:lifelinker/provider/persons.dart';
import 'package:lifelinker/view/add%20person/add_person_view.dart';
import 'package:lifelinker/view/edit%20person/edit_person_view.dart';
import 'package:lifelinker/view/persons%20list/components/empty_list.dart';
import 'package:lifelinker/view/persons%20list/components/error.dart';
import 'package:lifelinker/view/persons%20list/components/fab.dart';
import 'package:lifelinker/view/persons%20list/components/list_header.dart';
import 'package:lifelinker/view/persons%20list/components/person_card.dart';
import 'package:lifelinker/view/persons%20list/components/relationship_filter_chip.dart';
import 'package:lifelinker/view/persons%20list/components/search_bar.dart';
import 'package:provider/provider.dart';

class PerspnsleListView extends StatelessWidget {
  const PerspnsleListView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: Column(
        children: [
          const PerspnsListHeader(),
          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.widthMultiplier * 4,
              SizeConfig.heightMultiplier * 2,
              SizeConfig.widthMultiplier * 4,
              0,
            ),
            child: Column(
              children: [
                const PerspnsSearchBar(),
                Spacing.y(1.5),
                const RelationshipFilterChips(),
                Spacing.y(1.5),
              ],
            ),
          ),
          Expanded(
            child: Consumer<PersonsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (provider.hasError) return const PerspnsListError();
                if (provider.filteredPeople.isEmpty) {
                  return const PerspnsListEmpty();
                }
                return _buildList(context, provider);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: PerspnsListFab(onTap: () => _openAdd(context)),
    );
  }

  Widget _buildList(BuildContext context, PersonsProvider provider) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.widthMultiplier * 4,
        0,
        SizeConfig.widthMultiplier * 4,
        SizeConfig.heightMultiplier * 12.5,
      ),
      itemCount: provider.filteredPeople.length,
      separatorBuilder: (_, _) =>
          SizedBox(height: SizeConfig.heightMultiplier * 1.3),
      itemBuilder: (_, i) {
        final person = provider.filteredPeople[i];
        return PerspnsCard(
          person: person,
          onTap: () => _openEdit(context, person),
          onDelete: () => _confirmDelete(context, person, provider),
        );
      },
    );
  }

  Future<void> _openAdd(BuildContext context) async {
    final added = await Navigator.push<KnownPerson>(
      context,
      MaterialPageRoute(builder: (_) => const AddPersonView()),
    );
    if (added != null && context.mounted) {
      context.read<PersonsProvider>().fetchPeople();
    }
  }

  Future<void> _openEdit(BuildContext context, KnownPerson person) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditPersonView(person: person)),
    );
    if (changed == true && context.mounted) {
      context.read<PersonsProvider>().fetchPeople();
    }
  }

  void _confirmDelete(
    BuildContext context,
    KnownPerson person,
    PersonsProvider provider,
  ) {
    AppConfirmDialog.show(
      context: context,
      title: 'Remove Person',
      message:
          'Remove ${person.name} from the known people list? This will also delete all registered face data.',
      confirmLabel: 'Remove',
      isDestructive: true,
      onConfirm: () => provider.deletePerson(person.id),
    );
  }
}
