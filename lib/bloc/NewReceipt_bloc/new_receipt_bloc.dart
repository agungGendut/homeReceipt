import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:resepkita/model/CategoryData.dart';
import 'package:resepkita/model/DetailReceiptData.dart';
import 'package:resepkita/model/ListReceiptData.dart';
import 'package:resepkita/model/NewReceiptData.dart';
import 'package:resepkita/viewmodel/ApiRepository.dart';

part 'new_receipt_event.dart';
part 'new_receipt_state.dart';

class NewReceiptBloc extends Bloc<NewReceiptEvent, NewReceiptState> {
  NewReceipt newReceipt;
  ListReceipt listReceipt;
  CategoryReceipt categoryReceipt;
  DetailReceipt detailReceipt;
  NewReceiptBloc() : super(NewReceiptInitial()){
    on<NewReceiptEvent>((event, emit) async {
      await mapEventToStates(event, emit);
    });
  }

  Future<void> mapEventToStates(
      NewReceiptEvent event, Emitter<NewReceiptState> emit
      ) async {

    if (event is GetCategoryData){
      CategoryReceipt respo = await ApiRepository.getCategoryData();
      if (respo.status == true){
        this.categoryReceipt = respo;
        add(SuccessGetCategoryData(categoryReceipt));
      }
    }

    if (event is SuccessGetCategoryData){
      emit(ReceiptInitial(categoryReceipt: event.categoryReceipt, newReceipt: this.newReceipt, listReceipt: this.listReceipt));
    }

    if (event is GetNewReceiptData){
      emit(ReceiptUnitial());
      NewReceipt respo = await ApiRepository.getNewReceiptData();
      if (respo.status == true){
        this.newReceipt = respo;
        add(SuccessGetNewData(this.newReceipt));
      }
    }

    if (event is SuccessGetNewData){
      emit(ReceiptInitial(categoryReceipt: this.categoryReceipt, newReceipt: event.newReceipt, listReceipt: this.listReceipt));
    }

    if (event is GetListReceiptData){
      ListReceipt listRespo = await ApiRepository.getListReceiptData(event.page);
      if (listRespo.status == true){
        this.listReceipt = listRespo;
        add(SuccessGetListReceipt(this.listReceipt));
      }
    }

    if (event is SuccessGetListReceipt){
      emit(ReceiptInitial(categoryReceipt: this.categoryReceipt, newReceipt: this.newReceipt, listReceipt: event.listReceipt));
    }

    if (event is GetDetailReceiptData){
      DetailReceipt detailRespo = await ApiRepository.getDetailReceiptData(event.key);
      if (detailRespo.status == true){
        this.detailReceipt = detailRespo;
        emit(DetailInitial(detailReceipt: this.detailReceipt));
      }
    }
  }
}
