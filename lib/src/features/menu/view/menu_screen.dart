import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../localization/generated/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../order/bloc/order_bloc.dart';
import '../../order/view/order_screen.dart';
import '../bloc/menu_bloc.dart';
import '../models/menu_item.dart';
import '../models/menu_category.dart';
import 'widgets/menu_item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ItemScrollController _verticalScrollController = ItemScrollController();
  final ItemPositionsListener _verticalScrollListener =
      ItemPositionsListener.create();

  final ScrollController _horizontalScrollController = ScrollController();
  final Map<int, GlobalKey> _categoryButtonKeys = {};

  int _activeCategory = 0;

  List<MenuCategory> get _categories =>
      context.read<MenuBloc>().state.categories ?? [];

  List<MenuItem> get _items => context.read<MenuBloc>().state.items ?? [];

  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(const LoadCategoriesEvent());
    _verticalScrollListener.itemPositions
        .addListener(_updateActiveCategoryOnScroll);
  }

  @override
  void dispose() {
    _verticalScrollListener.itemPositions
        .removeListener(_updateActiveCategoryOnScroll);
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _updateActiveCategoryOnScroll() {
    final positions = _verticalScrollListener.itemPositions.value;
    if (positions.isEmpty) return;

    final firstVisibleIndex = positions.first.index;
    final newCategoryId = _categories[firstVisibleIndex].id;

    if (newCategoryId != _activeCategory) {
      _scrollActiveCategoryButtonToStart(newCategoryId);
    }
  }

  void _scrollToCategory(int categoryId) async {
    final index = _categories.indexWhere((c) => c.id == categoryId);
    if (index == -1) return;

    await _verticalScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    _scrollActiveCategoryButtonToStart(categoryId);

    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _scrollActiveCategoryButtonToStart(int categoryId) {
    setState(() {
      _activeCategory = categoryId;
    });
    final itemContext = _categoryButtonKeys[categoryId]?.currentContext;
    final listContext = context;

    if (itemContext != null) {
      final itemBox = itemContext.findRenderObject() as RenderBox;
      final listBox = listContext.findRenderObject() as RenderBox;

      final itemOffset =
          itemBox.localToGlobal(Offset.zero, ancestor: listBox).dx;

      _horizontalScrollController.animateTo(
        _horizontalScrollController.offset + itemOffset - 4,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      buildWhen: (previous, current) => current is! IdleMenuState,
      builder: (context, state) {
        if (state is ProgressMenuState && _categories.isEmpty) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (state is ErrorMenuState) {
          return Scaffold(
              body: Center(
            child: Text(
              AppLocalizations.of(context)!.dataLoadFailure,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ));
        }
        for (final category in _categories) {
          _categoryButtonKeys.putIfAbsent(category.id, () => GlobalKey());
        }
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.background,
              surfaceTintColor: AppColors.background,
              titleSpacing: 0,
              title: SizedBox(
                height: 36,
                child: ListView.builder(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isActive = category.id == _activeCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextButton(
                        key: _categoryButtonKeys[category.id],
                        onPressed: () => _scrollToCategory(category.id),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              isActive ? AppColors.blue : AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(8.0),
                        ),
                        child: Text(
                          category.name,
                          style: TextStyle(
                            color: isActive ? AppColors.white : AppColors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            body: ScrollablePositionedList.builder(
              itemScrollController: _verticalScrollController,
              itemPositionsListener: _verticalScrollListener,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final categoryItems = _items
                    .where((item) => item.category.id == category.id)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        category.name,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    categoryItems.isEmpty && state is ProgressMenuState
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categoryItems.length,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 210,
                            ),
                            itemBuilder: (context, itemIndex) {
                              return MenuItemCard(
                                  item: categoryItems[itemIndex]);
                            },
                          ),
                  ],
                );
              },
            ),
            floatingActionButton: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state.totalPrice == 0) return const SizedBox.shrink();
                return FloatingActionButton.extended(
                  onPressed: () {
                    showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) => BlocProvider.value(
                              value: context.read<OrderBloc>(),
                              child: const OrderScreen(),
                            ));
                  },
                  backgroundColor: AppColors.blue,
                  label: Text(
                    AppLocalizations.of(context)!.price(state.totalPrice),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.white,
                        ),
                  ),
                  icon: const Icon(Icons.local_mall, color: AppColors.white),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
