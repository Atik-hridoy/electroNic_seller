import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';


class HomeBottomNavigationBar extends GetView<HomeController> {
  const HomeBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 80,
            child: _NavItemsRow(),
          ),
        ),
      ),
    );
  }
}


class _NavItemsRow extends GetView<HomeController> {
  const _NavItemsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _BottomNavItem(
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: 'My Update',
              index: 0,
            )
            ),
            Expanded(child: _BottomNavItem(
              icon: Icons.inventory_2_outlined,
              activeIcon: Icons.inventory_2,
              label: 'Products',
              index: 1,
            )
            ),
            Expanded(child: _BottomNavItem(
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long,
              label: 'Orders',
              index: 2,
            )
            ),
            Expanded(child: _BottomNavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Account',
              index: 3,
          )
        ),
      ],
    );
  }
}

class _BottomNavItem extends GetView<HomeController> {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;

  const _BottomNavItem(
    {
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
  }
  );

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(builder: (ctrl) {
      final bool isActive = ctrl.selectedBottomNavIndex.value == index;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => ctrl.onBottomNavTap(index),
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? Colors.green.shade600 : Colors.grey[400],
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? Colors.green.shade600 : Colors.grey[400],
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                 ),
               ),
             ],
           ),
          ),
        );
       }
     );
   }
}
