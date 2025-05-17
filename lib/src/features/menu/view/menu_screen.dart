import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../data/category_repository.dart';
import '../data/menu_repository.dart';
import 'widgets/menu_item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  final Map<int, GlobalKey> _categorySliverKeys = {};
  final Map<int, GlobalKey> _categoryButtonKeys = {};
  bool _isJumpingToCategory = false;

  int _activeCategory = 0;

  @override
  void initState() {
    super.initState();
    for (var category in categories) {
      _categorySliverKeys[category.id] = GlobalKey();
      _categoryButtonKeys[category.id] = GlobalKey();
    }
    _verticalScrollController.addListener(_onMenuScroll);
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _onMenuScroll() {
    if (_isJumpingToCategory) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double visibleTopEdge = offset.dy;
    final double visibleBottomEdge = offset.dy + renderBox.size.height;

    for (final category in categories) {
      final sectionKey = _categorySliverKeys[category.id];
      final sectionRenderBox =
          sectionKey?.currentContext?.findRenderObject() as RenderBox?;

      if (sectionRenderBox != null) {
        final categoryOffset = sectionRenderBox.localToGlobal(Offset.zero).dy;

        if (categoryOffset >= visibleTopEdge &&
            categoryOffset < visibleBottomEdge) {
          _scrollCategoryButtonToStart(category.id);
          break;
        }
      }
    }
  }

  void _scrollToCategory(int categoryId) async {
    final keyContext = _categorySliverKeys[categoryId]?.currentContext;
    if (keyContext != null) {
      _isJumpingToCategory = true;
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _scrollCategoryButtonToStart(categoryId);

      await Future.delayed(const Duration(milliseconds: 400));
      _isJumpingToCategory = false;
    }
  }

  void _scrollCategoryButtonToStart(int categoryId) {
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
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
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
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (_) {
            _onMenuScroll();
            return true;
          },
          child: CustomScrollView(
            controller: _verticalScrollController,
            slivers: [
              for (var category in categories) ...[
                SliverToBoxAdapter(
                  child: Container(
                    key: _categorySliverKeys[
                        category.id],
                    padding: const EdgeInsets.all(16.0),
                    child: Text(category.name,
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final items = menuItems
                          .where((item) => item.category == category)
                          .toList();
                      return MenuItemCard(item: items[index]);
                    },
                        childCount: menuItems
                            .where((item) => item.category == category)
                            .length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 210,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
