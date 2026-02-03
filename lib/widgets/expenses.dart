import 'package:expense_program/models/expense.dart';
import 'package:expense_program/widgets/chart/chart.dart';
import 'package:expense_program/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_program/widgets/expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget{
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {

  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'كورس فلاتر',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work
    ),
    Expense(
        title: 'Cinema',
        amount: 15.97,
        date: DateTime.now(),
        category: Category.leisure
    )
  ];


  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense,)
    );
  }


  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
          content: const Text('تم حذف المصروف'),
          action: SnackBarAction(
              label: 'أستعادة',
              onPressed: () {
                setState(() {
                  _registeredExpenses.insert(expenseIndex, expense);
                });
              }
          ),
      )
    );
  }


  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('لايوجد اي مصروف. قم بأضافة مصروف'),
    );

    if (_registeredExpenses.isNotEmpty){
      mainContent =  ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Masroofi'),
        leading:
          IconButton(
              onPressed: _openAddExpenseOverlay ,
              icon: Icon(Icons.add)
          )

      ),
      
      body: width < 600
        ? Column(
         children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent
          ),
         ],
        )
        : Row(
         children: [
           Expanded(
               child: Chart(expenses: _registeredExpenses),
           ),

           Expanded(
           child: mainContent
           ),
         ],
       )
    );
  }
}