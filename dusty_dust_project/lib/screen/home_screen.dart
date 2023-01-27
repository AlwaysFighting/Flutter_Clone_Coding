import 'package:dusty_dust_project/component/category_card.dart';
import 'package:dusty_dust_project/component/main_app_bar.dart';
import 'package:dusty_dust_project/component/main_drawer.dart';
import 'package:dusty_dust_project/const/colors.dart';
import 'package:dusty_dust_project/repository/stat_repository.dart';
import 'package:flutter/material.dart';
import '../component/hourly_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState(){
    super.initState();
    fetchData();
  }

  fetchData() async {
    final statModel = await StatRepository.fetchData();
    print(statModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PRIMARY_COLOR,
        drawer: MainDrawer(),
        body: CustomScrollView(
          slivers: [
            MainAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CategoryCard(),
                  const SizedBox(height: 16.0),
                  HourlyCard(),
                ],
              ),
            )
          ],
        ),
    );
  }
}
