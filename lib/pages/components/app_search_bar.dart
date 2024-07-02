import 'package:flutter/material.dart';
import 'package:flutter_cool_card_swiper/constants.dart';
import 'package:flutter_cool_card_swiper/data.dart';
import 'package:flutter_cool_card_swiper/widgets/cool_swiper.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dentalTips = [
      {
        "title": "Brush Twice Daily",
        "description": "Use fluoride toothpaste for 2 minutes",
        "icon": "🪥"
      },
      {
        "title": "Floss Daily",
        "description": "Clean between teeth to remove plaque",
        "icon": "🦷"
      },
      {
        "title": "Limit Sugary Foods",
        "description": "Reduce risk of tooth decay",
        "icon": "🍬"
      },
      {
        "title": "Regular Check-ups",
        "description": "Visit your dentist every 6 months",
        "icon": "👨‍⚕️"
      },
      {
        "title": "Use Mouthwash",
        "description": "Rinse to kill bacteria and freshen breath",
        "icon": "💧"
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        height: Constants.cardHeight,
        child: CoolSwiper(
          children: List.generate(
            dentalTips.length,
            (index) => Container(
              height: Constants.cardHeight,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Data.colors[index % Data.colors.length],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dentalTips[index]["icon"]!,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const Spacer(),
                  Text(
                    dentalTips[index]["title"]!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dentalTips[index]["description"]!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}