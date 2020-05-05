import 'package:flutter/material.dart';
import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';
import '../models/transaction.dart';

class UserTransactionsState extends StatefulWidget {
  @override
  _UserTransactionsStateState createState() => _UserTransactionsStateState();
}

class _UserTransactionsStateState extends State<UserTransactionsState> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New shoes',
      amount: 69.66,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 15.54,
      date: DateTime.now(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NewTransactions(),
        TransactionList(_userTransactions),
      ],
    );
  }
}
