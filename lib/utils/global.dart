import 'package:driver_app/controllers/global_controller.dart';
import 'package:driver_app/models/users/user_model.dart';

void initializeGlobalController() {
  GlobalController.initialize();
}

String? getUserType() => GlobalController.getUserType();
String? getUid() => GlobalController.getUserId();
void setUserType(String userType) => GlobalController.setUserType(userType);
void setUser(UserModel user) => GlobalController.setUser(user);
