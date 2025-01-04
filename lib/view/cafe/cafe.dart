import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/cafe_controller/CafeController.dart';
import 'package:heavens_students/controller/cart_controller.dart';
import 'package:heavens_students/controller/homepage_controller/carousal_controller.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/CustomTextformField.dart';
import 'package:heavens_students/view/cafe/widgets/CategoryCard.dart';
import 'package:heavens_students/view/cafe/widgets/verticalCard.dart';
import 'package:heavens_students/view/cartpage/cartpage.dart';
import 'package:heavens_students/view/homepage/widgets/imageslider.dart';
import 'package:provider/provider.dart';

class Cafe extends StatefulWidget {
  const Cafe({super.key});

  @override
  State<Cafe> createState() => _CafeState();
}

class _CafeState extends State<Cafe> {
  List<bool> selectedCards = [];
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ini();
  }

  bool iscafeclosed = false;
  ini() async {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= 23 || hour < 6) {
      iscafeclosed = true;
    }
    // await context.read<CafeController>().getCafeItems();
    // await context.read<CafeController>().getCategoryName();
    context.read<CartController>().addOns.clear();
  }

  @override
  Widget build(BuildContext context) {
    var addons = context.watch<CartController>().addOns;
    var categoryModel = context.watch<CafeController>().categoryNameListModel;

    if (selectedCards.length != (categoryModel?.length ?? 0)) {
      selectedCards =
          List<bool>.generate(categoryModel?.length ?? 0, (index) => false);
    }
    var imageController =
        context.watch<CarousalImageController>().carousalModels;
    var cafe_controller = context.watch<CafeController>();
    double screenWidth = MediaQuery.of(context).size.width;
    return iscafeclosed
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: screenWidth * 0.35,
                  // ),
                  Image.asset(
                    "assets/images/cafe_closed.png",
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    "Our cafe is currently closed. \nWe look forward to serving you soon!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   // padding: EdgeInsets.symmetric(horizontal: 10),
                  //   // height: padding == null ? 50 : 0,
                  //   width: 90,
                  //   height: 35,
                  //   decoration: BoxDecoration(
                  //     color: ColorConstants.dark_red2,
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Center(
                  //     child: Container(
                  //         child: Text(
                  //       "Back",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 18,
                  //       ),
                  //     )),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey.withOpacity(0.1),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                leadingWidth: MediaQuery.of(context).size.width,
                backgroundColor: ColorConstants.primary_white,
                leading: isSearching
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 5),
                        child: buildSearchField(),
                      )
                    : Consumer<CafeController>(
                        builder: (context, cafeController, child) {
                          return Row(
                            children: [
                              SizedBox(width: 20),
                              Text(
                                selectedCards.every((element) => !element) &&
                                        isSearching == false
                                    ? "Heavens Cafe"
                                    : cafeController.selectedCategoryName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          );
                        },
                      ),
                actions: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (isSearching) {
                          isSearching = false;
                          context.read<CafeController>().resetCategory();
                          searchController.clear();
                        } else {
                          isSearching = true;
                          selectedCards =
                              List<bool>.filled(selectedCards.length, false);
                        }
                      });
                    },
                    child: Icon(Icons.search),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            // body: cafe_controller.isLoading
            // ? Center(
            //     child: CircularProgressIndicator(
            //     color: ColorConstants.dark_red,
            //   ))
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                context.read<CafeController>().resetCategory();
                                selectedCards = List<bool>.filled(
                                    categoryModel?.length ?? 0, false);
                              });
                            },
                            child: SizedBox(
                              child: CategoryCard(
                                category_name: "All Products",
                                isSelected:
                                    selectedCards.every((element) => !element),
                              ),
                              height: MediaQuery.of(context).size.height * .046,
                            ),
                          ),
                          SizedBox(width: 10),

                          // Categories List
                          Container(
                            height: MediaQuery.of(context).size.height * .07,
                            color: Colors.transparent,
                            child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              itemBuilder: (context, index) {
                                final category = categoryModel?[index];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      for (int i = 0;
                                          i < selectedCards.length;
                                          i++) {
                                        selectedCards[i] = i == index;
                                      }

                                      context
                                          .read<CafeController>()
                                          .getCategoryItems(category!.id);
                                      context
                                          .read<CafeController>()
                                          .setSelectedCategory(
                                              category.name, 5);
                                      log("Selected card: ${selectedCards}");
                                      isSearching = false;
                                    });
                                  },
                                  child: CategoryCard(
                                    isSelected: selectedCards[index],
                                    category_name: category?.name ?? "",
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 10),
                              itemCount: categoryModel?.length ?? 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  selectedCards.every((element) => !element) &&
                          isSearching == false
                      ? Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: ImageSlider(
                            imageList: imageController?[0].cafeImages ?? [],
                            isCafe: true,
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Consumer<CafeController>(
                            builder: (context, cafeController, child) {
                              if (cafeController.isLoading &&
                                  cafeController.isCategorySelected) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                        color: ColorConstants.dark_red),
                                    SizedBox(height: 30),
                                    Text("loading..",
                                        style: TextStyle(
                                            color: ColorConstants.dark_red)),
                                    SizedBox(height: 140)
                                  ],
                                );
                              }

                              log("is searching--$isSearching");

                              return NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (!cafeController.isLoading &&
                                      scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent &&
                                      !cafeController.isCategorySelected) {
                                    cafeController.getCafeItems();
                                  }
                                  return true;
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: cafeController.searchResponse == 404 &&
                                          isSearching
                                      ? Center(
                                          child: Text(
                                              "Currently, \n there are no items available!",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      ColorConstants.dark_red)),
                                        )
                                      : GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 0.63,
                                          ),
                                          itemBuilder: (context, index) {
                                            final items = cafeController.items;

                                            if (index >= items.length &&
                                                !cafeController
                                                    .isCategorySelected &&
                                                cafeController.isLoading) {
                                              return SizedBox();
                                            }
                                            // log("length--${items.length}");
                                            if (index >= items.length) {
                                              return SizedBox.shrink();
                                            }

                                            final item = items[index];
                                            var search =
                                                cafeController.searchModel;

                                            // log("item name ---${search?.length ?? 0}");

                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: ColorConstants
                                                      .primary_white,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: isSearching
                                                  ? VerticalCard(
                                                      lowsctock: search?[index]
                                                              .lowStock ??
                                                          0,
                                                      quantity: search?[index]
                                                              .quantity ??
                                                          0,
                                                      id: search?[index].id ??
                                                          "",
                                                      isCafe: true,
                                                      description: search?[
                                                                  index]
                                                              .description ??
                                                          "",
                                                      image: search?[index]
                                                              .image ??
                                                          "",
                                                      name: search?[index]
                                                              .itemName ??
                                                          "",
                                                      price:
                                                          "${search?[index].prize ?? ""}",
                                                    )
                                                  : VerticalCard(
                                                      lowsctock:
                                                          item.lowStock ?? 0,
                                                      quantity:
                                                          item.quantity ?? 0,
                                                      id: item.id ?? "",
                                                      isCafe: true,
                                                      description:
                                                          item.description ??
                                                              "",
                                                      image: item.image ?? "",
                                                      name: item.itemName ?? "",
                                                      price: "${item.prize}",
                                                    ),
                                            );
                                          },
                                          itemCount: isSearching == true
                                              ? cafeController
                                                      .searchModel?.length ??
                                                  0
                                              : cafeController.items.length +
                                                  (!cafeController
                                                              .isCategorySelected &&
                                                          cafeController
                                                              .isLoading
                                                      ? 1
                                                      : 0),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: addons.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: MediaQuery.of(context).size.width * 1),
                      width: MediaQuery.of(context).size.width * 1,
                      child: FloatingActionButton.extended(
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${context.watch<CartController>().addOns.length} Item added",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: ColorConstants.primary_white,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .27,
                            ),
                            Text(
                              'View Cart >',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: ColorConstants.primary_white,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: ColorConstants.dark_red,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage()));
                        },
                      ),
                    ),
                  )
                : null,
          );
  }

  Widget buildSearchField() {
    return CustomTextField(
      onChanged: (p0) {
        context.read<CafeController>().searchCafeItems(searchController.text);
      },
      controller: searchController,
      hintText: 'Search...',
      suffixIcon: InkWell(
        onTap: () {
          setState(() {
            isSearching = false;
          });
        },
        child: Icon(
          Icons.close,
          size: 16,
        ),
      ),
    );
  }
}
