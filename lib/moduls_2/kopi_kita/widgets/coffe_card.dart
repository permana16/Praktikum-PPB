import 'package:flutter/material.dart';

import '../models/coffe_item.dart';

class CoffeeCard extends StatelessWidget {
  final CoffeeItem item;

  const CoffeeCard({
    super.key,
    required this.item,
  });

  String _formatRupiah(int price) {
    final priceString = price.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < priceString.length; i++) {
      if (i > 0 &&
          (priceString.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(priceString[i]);
    }

    return 'Rp${buffer.toString()}';
  }

  bool get _isPromo {
    return item.badgeText.contains('DISKON') ||
        item.badgeText.contains('FAVORIT');
  }

  void _showOrderBottomSheet(BuildContext context) {
    final parentContext = context;

    String selectedSugar = 'Normal';
    String selectedIce = 'Normal';
    String selectedTopping = 'Tidak ada';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kustomisasi Pesanan',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        item.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 20),

                      // LEVEL GULA
                      Text(
                        'Level Gula',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        children: [
                          'Less',
                          'Normal',
                          'Extra',
                        ].map((value) {
                          return ChoiceChip(
                            label: Text(value),
                            selected:
                                selectedSugar == value,
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() {
                                  selectedSugar =
                                      value;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // LEVEL ES
                      Text(
                        'Level Es',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        children: [
                          'Tanpa Es',
                          'Sedikit',
                          'Normal',
                          'Extra',
                        ].map((value) {
                          return ChoiceChip(
                            label: Text(value),
                            selected:
                                selectedIce == value,
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() {
                                  selectedIce =
                                      value;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // TOPPING
                      Text(
                        'Topping',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        initialValue: selectedTopping,
                        decoration:
                            const InputDecoration(
                          border:
                              OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Tidak ada',
                            child:
                                Text('Tidak ada'),
                          ),
                          DropdownMenuItem(
                            value: 'Whipped Cream',
                            child: Text(
                                'Whipped Cream'),
                          ),
                          DropdownMenuItem(
                            value: 'Caramel',
                            child: Text('Caramel'),
                          ),
                          DropdownMenuItem(
                            value: 'Chocolate Chips',
                            child: Text(
                                'Chocolate Chips'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              selectedTopping =
                                  value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 24),

                      // RINGKASAN
                      Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                            16,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Text(
                                'Ringkasan Pesanan',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Gula: $selectedSugar',
                              ),
                              Text(
                                'Es: $selectedIce',
                              ),
                              Text(
                                'Topping: $selectedTopping',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // KONFIRMASI
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(
                              parentContext,
                            ).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${item.name} berhasil '
                                  'ditambahkan ke pesanan.',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.shopping_cart_checkout,
                          ),
                          label: const Text(
                            'Konfirmasi Pesanan',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          _showOrderBottomSheet(context);
        },

        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ICON PRODUK
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: theme.colorScheme
                          .primaryContainer,
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Icon(
                      item.icon,
                      size: 38,
                      color: theme.colorScheme
                          .onPrimaryContainer,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // KONTEN PRODUK
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // NAMA
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: theme.textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // KATEGORI
                        Text(
                          item.category,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: theme.textTheme
                              .bodySmall
                              ?.copyWith(
                            color: theme
                                .colorScheme
                                .primary,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // DESKRIPSI
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: theme.textTheme
                              .bodySmall,
                        ),

                        const SizedBox(height: 8),

                        // HARGA
                        Text(
                          _formatRupiah(item.price),
                          style: theme.textTheme
                              .titleSmall
                              ?.copyWith(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // RATING
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.rating
                                  .toStringAsFixed(1),
                              style: theme.textTheme
                                  .bodySmall
                                  ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // BADGE
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _isPromo
                      ? Colors.deepOrange
                      : theme.colorScheme
                          .secondaryContainer,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Text(
                  item.badgeText,
                  style: TextStyle(
                    color: _isPromo
                        ? Colors.white
                        : theme.colorScheme
                            .onSecondaryContainer,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}