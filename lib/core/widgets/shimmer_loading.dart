import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCardList extends StatelessWidget {
  final int itemCount;
  final bool isListTileStyle;

  const ShimmerCardList({
    super.key, 
    this.itemCount = 5,
    this.isListTileStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;
    final containerColor = isDark ? Colors.grey[850]! : Colors.white;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: isListTileStyle ? 40 : 48,
                    height: isListTileStyle ? 40 : 48,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 180,
                          height: 12,
                          decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 12,
                              decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(4)),
                            ),
                            if (!isListTileStyle) ...[
                              const Spacer(),
                              Container(
                                width: 60,
                                height: 24,
                                decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(12)),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
