import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/custom_avatar.dart';
import 'package:flutter_chat_app/common/widgets/custom_input.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/profile/services/profile_services.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileServices profileServices = ProfileServices();

  // user details form related
  final _userDetailsFormKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isFormEditable = false;
  bool isSubmitting = false;

// password form related
  final _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? isPasswordError;
  bool isPasswordFormVisible = false;
  bool isPasswordChanging = false;

  @override
  void initState() {
    setFormFields();
    super.initState();
  }

  setFormFields() {
    User user = Provider.of<UserProvider>(context, listen: false).user;

    if (user.firstName != null || user.lastName != null) {
      _fullNameController.text = '${user.firstName} ${user.lastName}';
    }

    _firstNameController.text = user.firstName ?? "";
    _lastNameController.text = user.lastName ?? "";
    _emailController.text = user.email;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void onEditForm() {
    setState(() {
      isFormEditable = true;
    });
  }

  void onCancelEdit() {
    setState(() {
      isFormEditable = false;
    });
  }

  void onSubmitForm() async {
    setState(() {
      isFormEditable = false;
      isSubmitting = true;
    });
    await profileServices.updateUserDetails(
      context: context,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
    );
    setFormFields();
    setState(() {
      isSubmitting = false;
    });
  }

  void showPasswordChangeForm() {
    setState(() {
      isPasswordFormVisible = true;
    });
  }

  void onPasswordChangeCancel() {
    setState(() {
      isPasswordFormVisible = false;
      isPasswordError = null;
    });
  }

  void onChangePassword() async {
    setState(() {
      isPasswordError = null;
    });
    if (_passwordFormKey.currentState!.validate() && arePasswordsValid()) {
      setState(() {
        isPasswordChanging = true;
      });
      await profileServices.changeUserPassword(
        context: context,
        newPassword: _newPasswordController.text,
      );
      setState(() {
        isPasswordChanging = false;
        isPasswordFormVisible = false;
      });
    }
  }

  bool arePasswordsValid() {
    bool isValid = false;
    String newPass = _newPasswordController.text;
    String confirmPass = _confirmPasswordController.text;

    if (newPass == confirmPass) {
      if (newPass.length < 7) {
        isValid = false;
        setState(() {
          isPasswordError = "Password should be more than 6 characters";
        });
      } else {
        return true;
      }
    } else {
      isValid = false;
      setState(() {
        isPasswordError = "Passwords don't match";
      });
    }
    return isValid;
  }

  void switchPasswordFormVisibility() {
    setState(() {
      isPasswordFormVisible = !isPasswordFormVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAvatar(
                  username: user.username,
                  fontSize: 30,
                  radius: 30,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: user.username,
                      child: Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Joined ${getRelativeTime(user.createdAt)} ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Material(
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _userDetailsFormKey,
                  child: Column(
                    children: [
                      if (_fullNameController.text.isNotEmpty &&
                          !isFormEditable)
                        CustomTextInput(
                          hintText: "Full Name",
                          controller: _fullNameController,
                          enabled: false,
                        ),
                      const SizedBox(height: 10),
                      if (isFormEditable)
                        CustomTextInput(
                          hintText: "Firstname",
                          controller: _firstNameController,
                          enabled: isFormEditable,
                        ),
                      const SizedBox(height: 10),
                      if (isFormEditable)
                        CustomTextInput(
                          hintText: "Lastname",
                          controller: _lastNameController,
                          enabled: isFormEditable,
                        ),
                      const SizedBox(height: 10),
                      CustomTextInput(
                        hintText: "Email",
                        controller: _emailController,
                        enabled: isFormEditable,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: isSubmitting
                            ? const Loader()
                            : isFormEditable
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 50,
                                          child: ElevatedButton.icon(
                                            onPressed: onCancelEdit,
                                            icon: const Icon(Icons.cancel),
                                            label: const Text("Cancel"),
                                            style: ButtonStyle(
                                              elevation:
                                                  MaterialStateProperty.all(1),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          height: 50,
                                          child: ElevatedButton.icon(
                                            onPressed: onSubmitForm,
                                            icon: const Icon(Icons.save),
                                            label: const Text("Update Details"),
                                            style: ButtonStyle(
                                              elevation:
                                                  MaterialStateProperty.all(1),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Colors.blue.shade900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : ElevatedButton.icon(
                                    onPressed: onEditForm,
                                    icon: const Icon(Icons.edit),
                                    label: const Text("Edit Details"),
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(1),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: switchPasswordFormVisibility,
              child: ListTile(
                tileColor:
                    isPasswordFormVisible ? Colors.blue[50] : Colors.white,
                title: const Text("Change Password"),
                trailing: Icon(
                  isPasswordFormVisible
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: Colors.black,
                ),
              ),
            ),
            if (isPasswordFormVisible == true)
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.blue[50],
                child: Form(
                  key: _passwordFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      CustomTextInput(
                        hintText: "New Password",
                        controller: _newPasswordController,
                      ),
                      const SizedBox(height: 10),
                      CustomTextInput(
                        hintText: "Confirm Password",
                        controller: _confirmPasswordController,
                      ),
                      if (isPasswordError != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            isPasswordError.toString(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      isPasswordChanging
                          ? SizedBox(
                              height: 50,
                              child: Loader(
                                color: Colors.blue.shade50,
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton.icon(
                                      onPressed: onPasswordChangeCancel,
                                      icon: const Icon(Icons.cancel),
                                      label: const Text("Cancel"),
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(1),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton.icon(
                                      onPressed: onChangePassword,
                                      icon: const Icon(Icons.save),
                                      label: const Text("Change Password"),
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(1),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.blue.shade900,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
