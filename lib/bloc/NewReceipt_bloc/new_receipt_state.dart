part of 'new_receipt_bloc.dart';

@immutable
abstract class NewReceiptState {}

class NewReceiptInitial extends NewReceiptState {}

class ReceiptUnitial extends NewReceiptState {}

class ReceiptInitial extends NewReceiptState {
  final NewReceipt newReceipt;
  final CategoryReceipt categoryReceipt;
  final ListReceipt listReceipt;
  ReceiptInitial({
    @required this.categoryReceipt,
    @required this.newReceipt,
    @required this.listReceipt,
  });
}

class DetailInitial extends NewReceiptState{
  final DetailReceipt detailReceipt;
  DetailInitial({
    @required this.detailReceipt,
  });
}
