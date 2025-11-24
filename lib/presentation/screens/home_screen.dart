import 'package:flutter/material.dart';
import 'package:invoice_generator/core/constants.dart';
import 'invoice_list_screen.dart';
import 'package:go_router/go_router.dart';
import '../widgets/fab_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text(
          'Invoices',
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.secondary,
        // bottom: TabBar(
        //   controller: _tabController,
        //   labelColor: Colors.white,
        //   unselectedLabelColor: Colors.grey,
        //   indicatorColor: Colors.white,
        //   tabs: const [
        //     Tab(text: 'Invoices'),
        //     Tab(text: 'Receipts'),
        //   ],
        // ),
      ),
      body: InvoiceListScreen(typeFilter: 'invoice'),

      // TabBarView(
      //   controller: _tabController,
      //   children: const [
      //     InvoiceListScreen(typeFilter: 'invoice'),
      //     InvoiceListScreen(typeFilter: 'receipt'),
      //   ],
      // ),
      floatingActionButton: FABButton(onPressed: () {
        context.push('/add-invoice');
      }),
    );
  }
}
