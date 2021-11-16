import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rim/custom_widgets/history_list_tile.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('history').snapshots(),
      builder: (context, snapshot) {
        List<HistoryListTile> transactionsList = [];
        final transactions = snapshot.data?.docs ?? [];
        for (var transaction in transactions) {
          transactionsList.add(
            HistoryListTile(
              componentId: transaction.get('component_id'),
              issueDate: transaction.get('issue_date'),
              quantityIssued: transaction.get('quantity_issued'),
              studentId: transaction.get('student_id'),
              returnDate: transaction.get('return_date'),
            ),
          );
        }
        return Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return transactionsList[index];
            },
            separatorBuilder: (context, index) => const Divider(
              thickness: 1.5,
              indent: 27.0,
              endIndent: 27.0,
            ),
            itemCount: transactionsList.length,
          ),
        );
      },
    );
  }
}
