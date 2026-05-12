import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/model/dite_plan.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/dite_plan.dart';
import 'package:lifelinker/view/caregiver/dite/components/meal_form_tile.dart';
import 'package:provider/provider.dart';

class DietFormSheet extends StatefulWidget {
  final UserModel patient;
  final DietPlanModel? existing;

  const DietFormSheet({super.key, required this.patient, this.existing});

  @override
  State<DietFormSheet> createState() => _DietFormSheetState();
}

class _DietFormSheetState extends State<DietFormSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final List<DietMeal> _meals = [];

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _titleCtrl.text = widget.existing!.title;
      _descCtrl.text = widget.existing!.description ?? '';
      _meals.addAll(widget.existing!.meals);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  int get _totalCalories => _meals.fold(0, (sum, m) => sum + m.totalCalories);

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Consumer<DietPlanProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.widthMultiplier * 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: SizeConfig.widthMultiplier * 10,
                    height: SizeConfig.heightMultiplier * 0.5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                AppText(
                  isEdit ? 'Edit Diet Plan' : 'Create Diet Plan',
                  size: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                CustomTextField(
                  controller: _titleCtrl,
                  hint: 'Plan title (e.g. Balanced Daily Diet)',
                  prefixIcon: Icons.restaurant_menu_rounded,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                CustomTextField(
                  controller: _descCtrl,
                  hint: 'Description (optional)',
                  prefixIcon: Icons.notes_rounded,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'Meals',
                      size: 13,
                      color: AppColors.textMedium,
                      fontWeight: FontWeight.w600,
                    ),
                    GestureDetector(
                      onTap: () => _showMealForm(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 3,
                          vertical: SizeConfig.heightMultiplier * 0.6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              color: AppColors.primary,
                              size: SizeConfig.widthMultiplier * 4,
                            ),
                            SizedBox(width: SizeConfig.widthMultiplier * 1),
                            AppText(
                              'Add Meal',
                              size: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                if (_meals.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.heightMultiplier * 1,
                    ),
                    child: AppText(
                      'No meals added yet',
                      size: 12,
                      color: AppColors.iconGrey,
                    ),
                  )
                else
                  Column(
                    children: _meals.asMap().entries.map((entry) {
                      return MealFormTile(
                        meal: entry.value,
                        onRemove: () =>
                            setState(() => _meals.removeAt(entry.key)),
                      );
                    }).toList(),
                  ),
                if (_meals.isNotEmpty) ...[
                  SizedBox(height: SizeConfig.heightMultiplier * 1),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 4,
                      vertical: SizeConfig.heightMultiplier * 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          'Total Daily Calories',
                          size: 13,
                          color: AppColors.successDark,
                          fontWeight: FontWeight.w600,
                        ),
                        AppText(
                          '$_totalCalories kcal',
                          size: 14,
                          color: AppColors.successDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: SizeConfig.heightMultiplier * 3),
                CustomButton(
                  text: isEdit ? 'Update Plan' : 'Save Plan',
                  isLoading: provider.isSaving,
                  onTap: () => _save(context, provider, isEdit),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMealForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _MealInputSheet(onSave: (meal) => setState(() => _meals.add(meal))),
    );
  }

  void _save(BuildContext context, DietPlanProvider provider, bool isEdit) {
    if (_titleCtrl.text.trim().isEmpty) return;
    final caregiverId = SharedPrefsService.getUID() ?? '';

    if (isEdit) {
      final updated = widget.existing!.copyWith(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        meals: _meals,
        totalDailyCalories: _totalCalories,
      );
      provider.updatePlan(
        context: context,
        plan: updated,
        onSuccess: () => Navigator.pop(context),
      );
    } else {
      final plan = DietPlanModel(
        id: '',
        patientId: widget.patient.uid,
        caregiverId: caregiverId,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        meals: _meals,
        totalDailyCalories: _totalCalories,
        isActive: true,
        createdAt: DateTime.now(),
      );
      provider.addPlan(
        context: context,
        plan: plan,
        onSuccess: () => Navigator.pop(context),
      );
    }
  }
}

class _MealInputSheet extends StatefulWidget {
  final ValueChanged<DietMeal> onSave;

  const _MealInputSheet({required this.onSave});

  @override
  State<_MealInputSheet> createState() => _MealInputSheetState();
}

class _MealInputSheetState extends State<_MealInputSheet> {
  MealType _selectedType = MealType.breakfast;
  final _timeCtrl = TextEditingController();
  final List<DietMealItem> _items = [];
  final _itemNameCtrl = TextEditingController();
  final _itemQtyCtrl = TextEditingController();
  final _itemCalCtrl = TextEditingController();

  @override
  void dispose() {
    _timeCtrl.dispose();
    _itemNameCtrl.dispose();
    _itemQtyCtrl.dispose();
    _itemCalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.widthMultiplier * 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: SizeConfig.widthMultiplier * 10,
                height: SizeConfig.heightMultiplier * 0.5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            AppText(
              'Add Meal',
              size: 17,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            AppText(
              'Meal Type',
              size: 12,
              color: AppColors.textMedium,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 1),
            _MealTypeSelector(
              selected: _selectedType,
              onSelect: (t) => setState(() => _selectedType = t),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 1.5),
            _buildField(
              'Time (e.g. 8:00 AM)',
              _timeCtrl,
              Icons.access_time_rounded,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'Food Items',
                  size: 12,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                ),
                GestureDetector(
                  onTap: _addItem,
                  child: Icon(
                    Icons.add_circle_rounded,
                    color: AppColors.primary,
                    size: SizeConfig.widthMultiplier * 6,
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 1),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildField(
                    'Item name',
                    _itemNameCtrl,
                    Icons.fastfood_rounded,
                  ),
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 2),
                Expanded(
                  flex: 2,
                  child: _buildField('Qty', _itemQtyCtrl, Icons.scale_rounded),
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 2),
                Expanded(
                  flex: 2,
                  child: _buildField(
                    'kcal',
                    _itemCalCtrl,
                    Icons.local_fire_department_rounded,
                    isNumber: true,
                  ),
                ),
              ],
            ),
            if (_items.isNotEmpty) ...[
              SizedBox(height: SizeConfig.heightMultiplier * 1.5),
              ..._items.asMap().entries.map(
                (e) => _ItemRow(
                  item: e.value,
                  onRemove: () => setState(() => _items.removeAt(e.key)),
                ),
              ),
            ],
            SizedBox(height: SizeConfig.heightMultiplier * 3),
            SizedBox(
              width: double.infinity,
              height: SizeConfig.heightMultiplier * 6.5,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: AppText(
                  'Add Meal',
                  size: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String hint,
    TextEditingController ctrl,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Container(
      height: SizeConfig.heightMultiplier * 6.5,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1.5,
          fontFamily: 'Poppins',
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: SizeConfig.textMultiplier * 1.4,
            fontFamily: 'Poppins',
            color: AppColors.iconGrey,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.iconGrey,
            size: SizeConfig.widthMultiplier * 4.5,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: SizeConfig.heightMultiplier * 1.8,
          ),
        ),
      ),
    );
  }

  void _addItem() {
    if (_itemNameCtrl.text.trim().isEmpty) return;
    setState(() {
      _items.add(
        DietMealItem(
          name: _itemNameCtrl.text.trim(),
          quantity: _itemQtyCtrl.text.trim(),
          calories: int.tryParse(_itemCalCtrl.text.trim()) ?? 0,
        ),
      );
      _itemNameCtrl.clear();
      _itemQtyCtrl.clear();
      _itemCalCtrl.clear();
    });
  }

  void _save() {
    if (_items.isEmpty) return;
    widget.onSave(
      DietMeal(type: _selectedType, time: _timeCtrl.text.trim(), items: _items),
    );
    Navigator.pop(context);
  }
}

class _MealTypeSelector extends StatelessWidget {
  final MealType selected;
  final ValueChanged<MealType> onSelect;

  const _MealTypeSelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final types = [
      (MealType.breakfast, 'Breakfast', Icons.wb_sunny_rounded),
      (MealType.lunch, 'Lunch', Icons.wb_cloudy_rounded),
      (MealType.dinner, 'Dinner', Icons.nights_stay_rounded),
      (MealType.snack, 'Snack', Icons.cookie_rounded),
    ];
    return Row(
      children: types.map((t) {
        final isSelected = selected == t.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(t.$1),
            child: Container(
              margin: EdgeInsets.only(
                right: t.$1 != MealType.snack
                    ? SizeConfig.widthMultiplier * 2
                    : 0,
              ),
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.heightMultiplier * 1.1,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    t.$3,
                    size: SizeConfig.widthMultiplier * 4.5,
                    color: isSelected ? Colors.white : AppColors.iconGrey,
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 0.3),
                  AppText(
                    t.$2,
                    size: 9,
                    color: isSelected ? Colors.white : AppColors.iconGrey,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final DietMealItem item;
  final VoidCallback onRemove;

  const _ItemRow({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 0.8),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 3,
        vertical: SizeConfig.heightMultiplier * 0.8,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: SizeConfig.widthMultiplier * 2,
            color: AppColors.primary,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 2),
          Expanded(
            child: AppText(
              '${item.name} — ${item.quantity}',
              size: 12,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppText(
            '${item.calories} kcal',
            size: 11,
            color: AppColors.successDark,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 2),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: SizeConfig.widthMultiplier * 4,
              color: AppColors.alert,
            ),
          ),
        ],
      ),
    );
  }
}
