import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:resepkita/model/CategoryData.dart';
import 'package:resepkita/model/NewReceiptData.dart';
import 'package:resepkita/viewmodel/ApiRepository.dart';

part 'new_receipt_event.dart';
part 'new_receipt_state.dart';

class NewReceiptBloc extends Bloc<NewReceiptEvent, NewReceiptState> {
  NewReceipt newReceipt;
  CategoryReceipt categoryReceipt;
  NewReceiptBloc() : super(NewReceiptInitial());

  @override
  Stream<NewReceiptState> mapEventToState(
      NewReceiptEvent event,
      ) async* {
    if (event is GetCategoryData){
      CategoryReceipt respo = await ApiRepository.getCategoryData();
      if (respo.status == true){
        this.categoryReceipt = respo;
        add(SuccessGetCategoryData(categoryReceipt));
      }
    }

    if (event is SuccessGetCategoryData){
      yield ReceiptInitial(categoryReceipt: event.categoryReceipt, newReceipt: this.newReceipt);
    }

    if (event is GetNewReceiptData){
      NewReceipt respo = await ApiRepository.getNewReceiptData();
      if (respo.status == true){
        this.newReceipt = respo;
        add(SuccessGetNewData(this.newReceipt));
      }
    }

    if (event is SuccessGetNewData){
      yield ReceiptInitial(categoryReceipt: this.categoryReceipt, newReceipt: event.newReceipt);
    }
  }
}
