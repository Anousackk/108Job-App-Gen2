import 'package:get/get.dart';

class LocalString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          "language": "Eng",
          "waiting": "Please wait...",
          "createAccount": "Create an Account",
          "alreadyHaveAccount": "I already have an account"
        },
        'lo_LA': {
          "language": "Lao",
          "waiting": "ກະລຸນາລໍຖ້າ...",
          "createAccount": "ສ້າງບັນຊີ",
          "alreadyHaveAccount": "ຂ້ອຍມີບັນຊີແລ້ວ"
        }
      };
}
