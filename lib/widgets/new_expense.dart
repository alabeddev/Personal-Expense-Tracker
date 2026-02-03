import 'package:flutter/material.dart';
import 'package:expense_program/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class NewExpense extends StatefulWidget{
  const NewExpense ({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {

  /* var _enteredTitle = '';

  void _saveTitleInput(String inputValue) {
    _enteredTitle = inputValue;
  } */

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year -1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }


  void _showDialog() {
    if(Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('لايوجد أدخال!!!'),
            content: const Text(
                'Plase make sure valid...'
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text('Ok')
              )
            ],
          )
      );
    }
    else {
      showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: const Text('لايوجد أدخال!!!'),
                content: const Text(
                    'Plase make sure valid...'
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text('Ok')
                  )
                ],
              )
      );
    }
  }


  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
         amountIsInvalid ||
        _selectedDate == null )
      {
        _showDialog();

        return;
      }

    widget.onAddExpense(
        Expense(
            title: _titleController.text,
            amount: enteredAmount,
            date: _selectedDate!,
            category: _selectedCategory
        )
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: TextField(
                            //onChanged: _saveTitleInput,
                            controller: _titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                                label: Text('العنوان')
                            ),
                          ),
                      ),
                      const SizedBox(width: 24,),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixText: '\$',
                              label: Text('السعر')
                          ),
                        ),
                      ),

                    ],
                  )
                else
                   TextField(
                    //onChanged: _saveTitleInput,
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                        label: Text('العنوان')
                    ),
                   ),

                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values.map(
                                (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                  category.name.toUpperCase()
                              ),
                            ),
                          ).toList(),

                          onChanged: (value) {
                            if(value == null) {
                              return;
                            }

                            setState(() {
                              _selectedCategory = value;
                            });
                          }
                      ),
                      const SizedBox(width: 24,),
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null ? 'قم بأختيار تأريخ'
                                    : formatter.format(_selectedDate!),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(
                                      Icons.calendar_month
                                  )
                              )
                            ],
                          )
                      )

                    ],
                  )
                else

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixText: '\$',
                              label: Text('السعر')
                          ),
                        ),
                      ),

                      SizedBox(width: 16,),
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null ? 'قم بأختيار تأريخ'
                                    : formatter.format(_selectedDate!),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(
                                      Icons.calendar_month
                                  )
                              )
                            ],
                          )
                      )
                    ],
                  ),


                const SizedBox(height: 16,),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('ألغاء')
                      ),

                      ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: Text(
                              'حفظ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values.map(
                                (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                  category.name.toUpperCase()
                              ),
                            ),
                          ).toList(),

                          onChanged: (value) {
                            if(value == null) {
                              return;
                            }

                            setState(() {
                              _selectedCategory = value;
                            });
                          }
                      ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('ألغاء')
                    ),

                    ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: Text(
                            'حفظ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      );
    });


  }
}