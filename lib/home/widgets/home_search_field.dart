import 'package:flutter/material.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  final TextEditingController searchController;
  final Function() onSearch;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onEditingComplete: onSearch,
      decoration: InputDecoration(
        hintText: "Buscar por nombre de usuario",
        border: const OutlineInputBorder(),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onSearch,
              child: const Icon(Icons.search),
            ),
            GestureDetector(
              onTap: () {
                searchController.clear();
                FocusManager.instance.primaryFocus!.unfocus();
              },
              child: const Icon(Icons.close),
            ),
            const SizedBox(
              width: 6,
            ),
          ],
        ),
      ),
    );
  }
}
