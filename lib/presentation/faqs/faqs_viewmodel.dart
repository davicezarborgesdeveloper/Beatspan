import 'package:flutter/material.dart';
import 'dart:ffi';
import '../../domain/enum/flow_state.dart';
import '../../domain/model/faqs.dart';
import '../../domain/usecase/faqs_usecase.dart';

class FaqsViewModel {
  final FaqsUseCase _faqsUseCase;
  FaqsViewModel(this._faqsUseCase);

  final state = ValueNotifier(FlowState.content);

  final faqs = ValueNotifier<List<Faq>?>(null);

  int get faqCount {
    return faqs.value?.length ?? 0;
  }

  void start() {
    _getFaqs();
  }

  void _getFaqs() async {
    state.value = FlowState.loading;
    (await _faqsUseCase.execute(Void)).fold((failure) {
      debugPrint('Erro:${failure.message}');
      state.value = FlowState.error;
    }, (success) {
      faqs.value = success;
      state.value = FlowState.success;
    });
  }
}
