import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final dynamic icon; 
  final bool isHighlighted;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xff006AFA) : const Color(0xffF0EFFF),
        borderRadius: BorderRadius.circular(15),
        border: isHighlighted
            ? null
            : Border.all(color: const Color(0xffC8C4FF), width: 2),
      ),
      child: Card(
        color: isHighlighted ? const Color(0xff006AFA) : const Color(0xffF0EFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon is IconData)
                Icon(
                  icon,
                  size: 40,
                  color: isHighlighted ? Colors.white : const Color(0xffF0EFFF),
                )
              else
                Image.asset(
                  icon,
                  width: 40,
                  height: 40,
                ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: isHighlighted ? Colors.white : const Color(0xff006AFA),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
