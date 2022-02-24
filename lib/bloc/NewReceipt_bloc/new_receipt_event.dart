part of 'new_receipt_bloc.dart';

@immutable
abstract class NewReceiptEvent {}

class GetCategoryData extends NewReceiptEvent{}

class GetNewReceiptData extends NewReceiptEvent{}

class GetListReceiptData extends NewReceiptEvent{
  final int page;
  GetListReceiptData(this.page);
}

class GetDetailReceiptData extends NewReceiptEvent{
  final String key;
  GetDetailReceiptData(this.key);
}

class SuccessGetCategoryData extends NewReceiptEvent{
  final CategoryReceipt categoryReceipt;
  SuccessGetCategoryData(this.categoryReceipt);
}

class SuccessGetNewData extends NewReceiptEvent{
  final NewReceipt newReceipt;
  SuccessGetNewData(this.newReceipt);
}

class SuccessGetListReceipt extends NewReceiptEvent{
  final ListReceipt listReceipt;
  SuccessGetListReceipt(this.listReceipt);
}
