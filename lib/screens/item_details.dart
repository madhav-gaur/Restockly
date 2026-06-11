import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDetails extends ConsumerStatefulWidget {
  final String itemId;
  const ItemDetails({super.key, required this.itemId});

  @override
  ConsumerState<ItemDetails> createState() => _ItemDetailsState();
    

}

class _ItemDetailsState extends ConsumerState<ItemDetails> {
  @override
  void initState() {
    super.initState();
   final itemId = widget.itemId; 
  }
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Text(widget.itemId),
    );
  }
}