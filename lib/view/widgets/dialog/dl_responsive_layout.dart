import 'package:flutter/material.dart';

import '../../../helper/responsive.dart';

class DLResponsiveLayout extends StatelessWidget {
  const DLResponsiveLayout({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: children.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  children[index],
                  const SizedBox(
                    height: 10,
                  )
                ],
              );
            })
        : GridView(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: Responsive.isTablet(context)
                  ? 8
                  : Responsive.isDesktop(context)
                      ? 9
                      : 8,
            ),
            children: children,
          );
  }
}
