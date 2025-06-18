part of 'purchased_view_cubit.dart';

class PurchasedViewState extends Equatable {
  const PurchasedViewState({this.packages = const [], this.selectedPackage});

  final List<PurchasedPackage> packages;
  final PurchasedPackage? selectedPackage;

  PurchasedViewState copyWith({
    List<PurchasedPackage>? packages,
    PurchasedPackage? selectedPackage,
  }) {
    return PurchasedViewState(
      packages: packages ?? this.packages,
      selectedPackage: selectedPackage ?? this.selectedPackage,
    );
  }

  @override
  List<Object?> get props => [packages, selectedPackage];
}
