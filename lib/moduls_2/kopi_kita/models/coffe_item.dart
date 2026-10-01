import 'package:flutter/material.dart';

class CoffeeItem {
  final int id;
  final String name;
  final String category;
  final int price;
  final String description;
  final double rating;
  final String badgeText;
  final IconData icon;

  const CoffeeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.rating,
    required this.badgeText,
    required this.icon,
  });

  static const List<CoffeeItem> sampleData = [
    CoffeeItem(
      id: 1,
      name: 'Caramel Latte',
      category: 'Coffee',
      price: 22000,
      description:
          'Espresso lembut dengan susu creamy dan sirup caramel yang manis.',
      rating: 4.8,
      badgeText: 'FAVORIT',
      icon: Icons.local_cafe_rounded,
    ),
    CoffeeItem(
      id: 2,
      name: 'Cappuccino',
      category: 'Coffee',
      price: 20000,
      description:
          'Perpaduan espresso, steamed milk, dan foam lembut dengan rasa seimbang.',
      rating: 4.7,
      badgeText: 'BEST SELLER',
      icon: Icons.coffee_rounded,
    ),
    CoffeeItem(
      id: 3,
      name: 'Matcha Latte',
      category: 'Non-Coffee',
      price: 23000,
      description:
          'Matcha premium Jepang dengan susu segar dan rasa creamy.',
      rating: 4.6,
      badgeText: 'NEW',
      icon: Icons.emoji_food_beverage_rounded,
    ),
    CoffeeItem(
      id: 4,
      name: 'Chocolate Milk',
      category: 'Non-Coffee',
      price: 18000,
      description:
          'Minuman cokelat creamy dengan rasa manis dan tekstur lembut.',
      rating: 4.5,
      badgeText: 'DISKON 20%',
      icon: Icons.local_drink_rounded,
    ),
    CoffeeItem(
      id: 5,
      name: 'Croissant Butter',
      category: 'Bakery',
      price: 17000,
      description:
          'Croissant renyah dengan aroma butter dan lapisan pastry yang lembut.',
      rating: 4.8,
      badgeText: 'FAVORIT',
      icon: Icons.bakery_dining_rounded,
    ),
    CoffeeItem(
      id: 6,
      name: 'Chocolate Muffin',
      category: 'Bakery',
      price: 15000,
      description:
          'Muffin cokelat lembut dengan chocolate chips yang cocok untuk teman kopi.',
      rating: 4.6,
      badgeText: 'NEW',
      icon: Icons.cake_rounded,
    ),
  ];
}