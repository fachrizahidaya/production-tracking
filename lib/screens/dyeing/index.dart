import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/layout/custom_app_bar.dart';
import 'package:production_tracking/components/master/layout/custom_card.dart';
import 'package:production_tracking/components/master/layout/custom_list.dart';
import 'package:production_tracking/components/master/layout/custom_search_bar.dart';
import 'package:production_tracking/models/process/dyeing.dart';

class Dyeing extends StatefulWidget {
  const Dyeing({super.key});

  @override
  State<Dyeing> createState() => _DyeingState();
}

class _DyeingState extends State<Dyeing> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  void _handleChangeSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dyeing',
        onReturn: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        color: const Color(0xFFEBEBEB),
        child: Column(
          children: [
            CustomSearchBar(handleSearchChange: _handleChangeSearch),
            Expanded(
                child: CustomList(
              service: DyeingService(),
              searchQuery: _searchQuery,
              canCreate: true,
              canUpdate: null,
              itemBuilder: (item) =>
                  CustomCard(child: ListTile(title: Text('test'))),
            ))
          ],
        ),
      ),
    );
  }
}
