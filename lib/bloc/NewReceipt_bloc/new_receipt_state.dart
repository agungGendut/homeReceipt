part of 'new_receipt_bloc.dart';

@immutable
abstract class NewReceiptState {}

class NewReceiptInitial extends NewReceiptState {}

class ReceiptInitial extends NewReceiptState {
  final NewReceipt newReceipt;
  final CategoryReceipt categoryReceipt;
  ReceiptInitial({
    @required this.categoryReceipt,
    @required this.newReceipt,
  });
}
