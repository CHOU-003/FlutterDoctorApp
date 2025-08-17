import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:practice/widget/category_card.dart';

class MedicalRoom extends StatefulWidget {
  const MedicalRoom({super.key});

  @override
  State<MedicalRoom> createState() => _MedicalRoomState();
}

class _MedicalRoomState extends State<MedicalRoom> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        "title": AppLocalizations.of(context)!.cardiologist,
        "icon": "assets/images/heart.png"
      },
      {
        "title": AppLocalizations.of(context)!.dentist,
        "icon": "assets/images/dental.png"
      },
      {
        "title": AppLocalizations.of(context)!.ophthalmologist,
        "icon": "assets/images/onco.png"
      },
      {
        "title": AppLocalizations.of(context)!.ophthalmologist,
        "icon": "assets/images/cancer 1.png"
      },
      {
        "title": AppLocalizations.of(context)!.ophthalmologist,
        "icon": "assets/images/onco.png"
      },
      {
        "title": AppLocalizations.of(context)!.ophthalmologist,
        "icon": "assets/images/onco.png"
      },
      {
        "title": AppLocalizations.of(context)!.ophthalmologist,
        "icon": "assets/images/onco.png"
      },
      {
        "title": AppLocalizations.of(context)!.ophthalmologist,
        "icon": "assets/images/onco.png"
      },
      {
        "title": AppLocalizations.of(context)!.ophthalmologist,
        "icon": "assets/images/onco.png"
      },
      {
        "title": AppLocalizations.of(context)!.seeAll,
        "icon": "assets/images/grid.png",
      },
    ];

    // nếu showAll = false thì chỉ lấy 7 cái đầu + SeeAll
    final displayList = !showAll && categories.length > 8
        ? [
            ...categories.take(7),
            {
              "title": AppLocalizations.of(context)!.seeAll,
              "icon": "assets/images/grid.png",
              "isSeeAll": true
            }
          ]
        : categories;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.findByCategory,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: displayList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cột
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final category = displayList[index];
            final isSeeAll = category["isSeeAll"] == true;

            return GestureDetector(
              onTap: () {
                if (isSeeAll) {
                  setState(() {
                    showAll = true;
                  });
                }
              },
              child: CategoryCard(
                title: category["title"] as String,
                icon: category["icon"]!,
                isHighlighted: isSeeAll,
              ),
            );
          },
        ),
      ),
    );
  }
}
