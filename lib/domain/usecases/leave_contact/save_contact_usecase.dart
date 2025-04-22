import 'package:fpdart/fpdart.dart';
import 'package:monkey_stories/core/error/failures.dart';
import 'package:monkey_stories/core/usecases/usecase.dart';
import 'package:monkey_stories/domain/repositories/leave_contact_repository.dart';

class SaveContactUsecase extends UseCase<void, ContactParams> {
  final LeaveContactRepository _leaveContactRepository;

  SaveContactUsecase(this._leaveContactRepository);

  @override
  Future<Either<ServerFailureWithCode, void>> call(ContactParams params) async {
    return _leaveContactRepository.saveContact(params);
  }
}

class ContactParams {
  final String? name;
  final String phone;
  final String countryCode;
  final String? productId;
  final String? utmMedium;
  final String? utmCampaign;
  final int? profileId;

  const ContactParams({
    this.name,
    required this.phone,
    required this.countryCode,
    this.productId,
    this.utmMedium,
    this.utmCampaign,
    this.profileId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '',
      'phone': '$countryCode$phone',
      'productId': productId ?? '',
      'utmMedium': utmMedium ?? '',
      'utmCampaign': utmCampaign ?? '',
      'profileId': profileId ?? '',
    };
  }
}
