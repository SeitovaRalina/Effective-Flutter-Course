import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final ScrollController _menuScrollController = ScrollController();
  final ScrollController _categoriesScrollController = ScrollController();
  final GlobalKey _categoriesKey = GlobalKey();
  final Map<int, GlobalKey> _categoryKeys = {};
  int _activeCategory = 0;

  @override
  void initState() {
    super.initState();
    _initializeCategoryKeys();
    _menuScrollController.addListener(_onMenuScroll);
  }

  void _initializeCategoryKeys() {
    for (var category in categories) {
      _categoryKeys[category.id] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _menuScrollController.dispose();
    _categoriesScrollController.dispose();
    super.dispose();
  }

  void _onMenuScroll() {
    int? newActiveCategory;
    double minOffset = double.infinity;

    debugPrint("----- onMenuScroll Triggered -----");

    for (var category in categories) {
      final keyContext = _categoryKeys[category.id]?.currentContext;
      if (keyContext != null) {
        final renderObject = keyContext.findRenderObject();
        final viewport = RenderAbstractViewport.of(renderObject);

        if (renderObject is RenderSliver) {
          final offset = viewport.getOffsetToReveal(renderObject, 0.0).offset;

          debugPrint("Category: $category, Offset: $offset");

          // Если заголовок находится в верхней части экрана, но еще не исчез
          if (offset > 0 && offset < minOffset) {
            minOffset = offset;
            newActiveCategory = category.id;
          }
        }
      }
    }

    debugPrint("New Active Category: $newActiveCategory");

    // Обновляем активную категорию, если она изменилась
    if (newActiveCategory != null && newActiveCategory != _activeCategory) {
      setState(() {
        _activeCategory = newActiveCategory!;
      });

      // Прокручиваем строку категорий, чтобы активная была слева
      _scrollCategoriesToActive(newActiveCategory);
    }
  }

  void _scrollCategoriesToActive(int categoryId) {
    final categoryIndex = categories.indexOf(categories[categoryId]);
    if (categoryIndex != -1) {
      _categoriesScrollController.animateTo(
        categoryIndex * 100.0, // Примерная ширина элемента
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToCategory(int categoryId) {
    final keyContext = _categoryKeys[categoryId]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _activeCategory = categoryId;
      });
      _scrollCategoriesToActive(categoryId);
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
              key: _categoriesKey,
              controller: _categoriesScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isActive = category.id == _activeCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: TextButton(
                    onPressed: () {
                      _scrollToCategory(category.id);
                    },
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
            controller: _menuScrollController,
            slivers: [
              for (var category in categories) ...[
                SliverToBoxAdapter(
                  key: _categoryKeys[category.id],
                  child: Padding(
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