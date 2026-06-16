import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restockly/models/stock_transaction_model.dart';
import 'package:restockly/models/user_model.dart';
import 'package:restockly/themes/color_const.dart';
import 'package:restockly/widgets/const_widget.dart';

ListTile transactionListTile({
  required String transactionType,
  required StockTransactionModel currLog,
  required String unit,
  required UserModel membersData,
}) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 8),
    tileColor: background,
    leading: CircleAvatar(
      radius: 17,
      backgroundColor: transactionType == "IN" ? green : danger,
      child: Icon(
        transactionType == "IN" ? Icons.add : Icons.remove,
        color: whiteText,
        size: 25,
      ),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "${transactionType == "IN" ? "Added" : "Used"} ${(currLog.newQuantity - currLog.oldQuantity).abs()} $unit ${currLog.itemName}",
            style: mediumTextStyle(),
          ),
        ),
        Text(
          "${currLog.oldQuantity} $unit -> ${currLog.newQuantity} $unit",
          style: smallTextStyle().copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: transactionType == "IN" ? green : danger,
          ),
        ),
      ],
    ),
    subtitle: SizedBox(
      width: 50,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          if (currLog.note != "")
            Text(
              "Note: ${currLog.note}",
              style: mediumTextStyle().copyWith(color: textSecondary),
            ),
          Text(
            "By ${membersData.name} on ${DateFormat("d MMM, h:mm a").format(currLog.createdAt)}",
            style: smallTextStyle().copyWith(fontSize: 12),
          ),
        ],
      ),
    ),
    // trailing:
  );
}
