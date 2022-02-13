part of 'new_receipt_bloc.dart';

@immutable
abstract class NewReceiptEvent {}

class GetCategoryData extends NewReceiptEvent{}

class GetNewReceiptData extends NewReceiptEvent{}

class SuccessGetCategoryData extends NewReceiptEvent{
  final CategoryReceipt categoryReceipt;
  SuccessGetCategoryData(this.categoryReceipt);
}

class SuccessGetNewData extends NewReceiptEvent{
  final NewReceipt newReceipt;
  SuccessGetNewData(this.newReceipt);
}
