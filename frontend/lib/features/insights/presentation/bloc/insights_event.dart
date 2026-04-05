import 'package:equatable/equatable.dart';

class InsightsEvent extends Equatable {
  const InsightsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class FetchInsightsEvent extends InsightsEvent {
  const FetchInsightsEvent();
}
