import 'package:flutter/material.dart';
import 'package:petrol_assist_mobile/views/settings_view.dart';
import 'package:provider/provider.dart';

import '../components/component_round_button.dart';
import '../resources/colours.dart';
import '../resources/text_styles.dart';
import '../utilities/utils.dart';
import '../view_models/edit_profile_vm.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {

  final EditProfileViewModel _editProfileViewModel = EditProfileViewModel();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _emailAddressFocusNode = FocusNode();
  final Icon _iconTextField = const Icon(Icons.info_sharp);
  final Icon _iconMobileField = const Icon(Icons.phone_android_sharp);
  final Icon _iconEmailField = const Icon(Icons.email_sharp);


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailAddressController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _mobileFocusNode.dispose();
    _emailAddressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;


    void textFieldValidateForm() {
      /*if (_emailController.text.isEmpty) {
        Utils.snackBar("Email can't be empty!", context);
      } else if (!_emailController.text.contains("@")) {
        Utils.snackBar("Email must contain @", context);
      } else if (_passwordController.text.isEmpty) {
        Utils.snackBar("Password can't be empty!", context);
      } else if (_passwordController.text.length < 6) {
        Utils.snackBar("Password must be more than 6 letter's", context);
      } else if (_passwordController.text.toString() !=
          _confirmPasswordController.text.toString()) {
        Utils.snackBar("Both Password's must be same", context);
      } else {
        final _authViewModel =
        Provider.of<AuthViewModel>(context, listen: false);
        _authViewModel.signUpApi(getUserCredentials(), context);
      }*/
    }

    return Scaffold(
      backgroundColor: AppColours.blackColour1,
      appBar: AppBar(
        backgroundColor: AppColours.greyColour,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: AppColours.highlightColour,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_sharp,
              color: AppColours.highlightColour,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsView(),
                  ));
            },
          ),
        ],
      ),
      body:ChangeNotifierProvider<EditProfileViewModel>(
        create: (BuildContext context) =>
        _editProfileViewModel,
        child: Consumer<EditProfileViewModel>(builder: (context, value, _){
          return Container(
            padding: const EdgeInsets.only(
                left: 16,
                top: 24,
                right: 16
            ),
            child: ListView(
              children: <Widget>[
                //  Edit Profile text
                const Text(
                  "Profile",
                  style: PATextStyles.largeTextBold,
                ),
                //  Add some space
                const SizedBox( height: 16,),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 132,
                        height: 132,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: AppColours.highlightColour,
                            ),
                            //  add some shadow
                            boxShadow:[
                              BoxShadow(
                                spreadRadius: 2, blurRadius: 10,
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(-3 , 9),
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: profileImage(value.getUserPhotoUrl())
                        ),
                      ),
                      // Edit button, using the positioned widget.  Remember in order
                      // to use, it must be a descendant of a Stack
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColours.highlightColour,
                            border: Border.all(
                              width: 4,
                              color: AppColours.blackColour2,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Form elements
                // Build form
                editProfile(height, textFieldValidateForm, context, _editProfileViewModel),
              ],
            ),
          );
        }),
      ),
    );
  }

  TextField textField(
      String hintText,
      TextEditingController textEditingController,
      FocusNode textFocusNode,
      Icon icon,
      [FocusNode? nextTextFocusNode, String? initialValue]
      ) {

    var hasNextNode = nextTextFocusNode;
    if(hasNextNode != null){
      textEditingController.text = (initialValue != null) ? initialValue : "";
      return TextField(
        controller: textEditingController,
        keyboardType: TextInputType.text,
        focusNode: textFocusNode,
        style: PATextStyles.regularText,
        onSubmitted: (value) {
          // After submitting the value for this field,
          // click done on keyboard, focus on the next
          // item (nextTextFocusNode).
          Utils.changeFocusNode(context,
              current: textFocusNode, next: nextTextFocusNode!);
        },
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: icon,
        ),
      );
    }else{
      textEditingController.text = (initialValue != null) ? initialValue : "";
      return TextField(
        controller: textEditingController,
        keyboardType: TextInputType.text,
        focusNode: textFocusNode,
        style: PATextStyles.regularText,
        onSubmitted: (value) {
          // After submitting the value for this field,
          // click done on keyboard, focus on the next
          // item (nextTextFocusNode).
          Utils.changeFocusNode(context,
              current: textFocusNode, next: nextTextFocusNode!);
        },
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: icon,
        ),
      );
    }
  }

  Padding editProfile(double height, void Function() textFieldValidate, BuildContext context, EditProfileViewModel vm){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*const CheckCircleIcon(),*/
            SizedBox(height: height * .08),

            textField(
                "First name",
                _firstNameController,
                _firstNameFocusNode,
                _iconTextField,
                _lastNameFocusNode,
                vm.getUser?.firstName

            ),
            SizedBox(height: height * .02),
            textField(
                "Last name",
                _lastNameController,
                _lastNameFocusNode,
                _iconTextField,
                _mobileFocusNode,
                vm.getUser?.lastName
            ),
            SizedBox(height: height * .02),
            textField(
                "Mobile",
                _mobileController,
                _mobileFocusNode,
                _iconMobileField,
                _emailAddressFocusNode,
                "077 155 32367"
            ),
            SizedBox(height: height * .02),
            textField(
                "Email",
                _emailAddressController,
                _emailAddressFocusNode,
                _iconEmailField,
                null,
                vm.getUser?.emailAddress
            ),
            SizedBox(height: height * .02),
            SizedBox(height: height * .05),
            Consumer<EditProfileViewModel>(
              builder: (context, value, child){
                return RoundButton(
                  title: "Update",
                  loading: value.editSettingsLoading,
                  onTap: textFieldValidate,
                );
              },
            ),
            SizedBox(height: height * .02),
          ],
        )
    );
  }

  DecorationImage profileImage(String? image){

    if(image != null && image.isNotEmpty){
      // use the network image
      return DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover
      );
    }else{
      // default image
      return const DecorationImage(
          image: AssetImage("assets/images/mini_countryman.jpg"),
          fit: BoxFit.cover
      );
    }
  }

}
