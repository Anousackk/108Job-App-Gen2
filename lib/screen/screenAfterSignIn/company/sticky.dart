// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';

class Company extends StatefulWidget {
  const Company({Key? key}) : super(key: key);

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sliver Tools Example'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Sliver Tools Example'),
              background: Image.network(
                'https://via.placeholder.com/500',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              // minHeight: 60,
              // maxHeight: 100,
              child: Container(
                height: 60,
                color: Colors.blue,
                alignment: Alignment.center,
                child: Text(
                  'Fixed Text',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
              childCount: 20,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text(
                'Sliver Tools Example',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    this.minHeight,
    this.maxHeight,
    required this.child,
  });

  final double? minHeight;
  final double? maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight ?? 60;

  @override
  double get maxExtent => maxHeight ?? 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
