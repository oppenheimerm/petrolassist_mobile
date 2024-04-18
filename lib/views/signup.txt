import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_constants.dart';
import '../components/component_bkgrd_img.dart';
import '../components/component_headline_text.dart';
import '../components/component_round_button.dart';
import '../resources/colours.dart';
import '../utilities/utils.dart';
import '../view_models/auth_vm.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Provider
  final ValueNotifier<bool> _obscurePass = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirmPass = ValueNotifier<bool>(true);

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  late bool _acceptTerms = false;
  //  By properly disposing of resources and unregistering event listeners, you
  //  ensure that your app is efficient and responsive, even as widgets are created
  //  and destroyed
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _mobileFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _obscurePass.dispose();
    super.dispose();
  }

  bool _validateMobileUK(String number){
    //https://www.regextester.com/104299
    RegExp exp = RegExp(r'(((\+44(\s\(0\)\s|\s0\s|\s)?)|0)7\d{3}(\s)?\d{6})');
    var valid = exp.hasMatch(number);
    return valid;
  }

  void textFieldValidate() async {
    if (_emailController.text.isEmpty ) {
      Utils.snackBar("Email can't be empty!", context);
    }
    else if(EmailValidator.validate(_emailController.text) == false){
      Utils.snackBar("Email not valid.", context);
    } else if (_passwordController.text.isEmpty) {
      Utils.snackBar("Password can't be empty!", context);
    } else if (_acceptTerms == false) {
      Utils.snackBar("You must agree to terms in order to register.", context);
    }else if (_passwordController.text.length < 6) {
      Utils.snackBar("Password must be a minimum of 6 characters.", context);
    }else if (_passwordController.text.toString() !=
        _confirmPasswordController.text.toString()) {
      Utils.snackBar("Password and confirm password must match.", context);
    }else if(_mobileController.text.isEmpty){
      Utils.snackBar("A valid UK phone number is required.", context);
    }else if(_validateMobileUK(_mobileController.text) == false){
      Utils.snackBar("Please enter a valid UK phone number.", context);
    } else {
      final authViewModel =
      Provider.of<AuthViewModel>(context, listen: false);
      final authenticateUserStatus = await authViewModel.authenticateUser(
          _emailController.text.trim().toString(),
          _passwordController.text.trim().toString()
      ).then((status) {
        if(context.mounted){
          if(status != null)
          {
            if(status.success)
            {
              // Navigate to the home screen using the named route.
              Navigator.pushNamed(context, AppConsts.rootHome);
            }else{
              var errMsg = status.errorMessage ?? "Could not log in";
              debugPrint(errMsg);
              Utils.snackBar(errMsg, context);
            }
          }else{
            //  Let user know
            // Error is logged further up the chain as either a
            //  network error or auth
            Utils.snackBar("Could not login, please contact help desk.", context);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // textFieldValidate(){}

    return PopScope(
      //  When false, blocks the current route from being popped.
      //  https://api.flutter.dev/flutter/widgets/PopScope/canPop.html
      //// Android User's can simply exit from app by pressing back button
      canPop: true,
      child: Scaffold(
        body: Stack(
          children: [ //assets/images/bg_1.jpg
            const BackgroundImage(imageUrl: "assets/images/bg_signup.jpg", fit: BoxFit.cover),
            SingleChildScrollView(
              child: signUp(height, textFieldValidate, context),
            ),
          ],
        ),
      ),
    );

  }

  Padding signUp(
      double height,
      void Function() TextFieldValidate,
      BuildContext context
      )
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: height * .06),
          const Headline(title: "Register", colour: Colors.white),
          SizedBox(height: height * .04),
          firstName(),
          SizedBox(height: height * .02),
          lastName(),
          SizedBox(height: height * .02),
          email(),
          SizedBox(height: height * .02),
          mobile(),
          SizedBox(height: height * .02,),
          password(),
          SizedBox(height: height * .02),
          confirmPassword(),
          SizedBox(height: height * .02),
          acceptTerms(),
          SizedBox(height: height * .05),
          Consumer<AuthViewModel>(
            builder: (context, value, child) {
              return RoundButton(
                  title: "Login",
                  loading: value.loginLoading,
                  onTap: () {
                    textFieldValidate();
                  });
            },
          ),
          SizedBox(height: height * .02),
          buildLoginQueryOption(context),
        ],
      ),
    );
  }

  Widget buildLoginQueryOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppConsts.rootLogin);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors
                .click, // Icon changed when user hover over the container
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: AppColours.buttonOKColour,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextField firstName(){
    return TextField(
      style: const TextStyle(),
      controller: _firstNameController,
      keyboardType: TextInputType.text,
      focusNode: _firstNameFocusNode,
      onSubmitted: (value) {
        // After submitting email, click done on keyboard, focus on the password bar
        Utils.changeFocusNode(context,
            current: _firstNameFocusNode, next: _lastNameFocusNode);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        filled: true,
        fillColor: AppColours.blackColour1.withOpacity(0.85),
        hintText: "Firstname",
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        prefixIcon: const Icon(Icons.email_sharp),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColours.greyColour,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  TextField lastName(){
    return TextField(
      style: const TextStyle(),
      controller: _lastNameController,
      keyboardType: TextInputType.text,
      focusNode: _lastNameFocusNode,
      onSubmitted: (value) {
        // After submitting email, click done on keyboard, focus on the password bar
        Utils.changeFocusNode(context,
            current: _lastNameFocusNode, next: _emailFocusNode);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        filled: true,
        fillColor: AppColours.blackColour1.withOpacity(0.85),
        hintText: "Lastname",
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        prefixIcon: const Icon(Icons.email_sharp),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColours.greyColour,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  TextField email() {
    return TextField(
      style: const TextStyle(
      ),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      focusNode: _emailFocusNode,
      onSubmitted: (value) {
        // After submitting email, click done on keyboard, focus on the password bar
        Utils.changeFocusNode(context,
            current: _emailFocusNode, next: _mobileFocusNode);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        filled: true,
        fillColor: AppColours.blackColour1.withOpacity(0.85),
        hintText: "Email",
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        prefixIcon: const Icon(Icons.email_outlined),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColours.greyColour,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  TextField mobile() {
    return TextField(
      style: const TextStyle(
      ),
      controller: _mobileController,
      keyboardType: TextInputType.phone,
      focusNode: _mobileFocusNode,
      onSubmitted: (value) {
        // After submitting email, click done on keyboard, focus on the password bar
        Utils.changeFocusNode(context,
            current: _mobileFocusNode, next: _passwordFocusNode);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        filled: true,
        fillColor: AppColours.blackColour1.withOpacity(0.85),
        hintText: "Mobile number",
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        prefixIcon: const Icon(Icons.phone_iphone_sharp),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColours.greyColour,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  ValueListenableBuilder<bool> password() {
    return ValueListenableBuilder(
      valueListenable: _obscurePass,
      builder: (context, value, child) {
        return TextField(
          controller: _passwordController,
          obscureText: value,
          obscuringCharacter: '#', // Password secured by showing -> #######
          focusNode: _passwordFocusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),

            ),
            filled: true,
            fillColor: AppColours.blackColour1.withOpacity(0.85),
            hintText: "Password",
            prefixIcon: const Icon(Icons.lock_open_sharp),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColours.greyColour,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            suffixIcon: InkWell(
              onTap: () {
                _obscurePass.value = !_obscurePass.value;
              },
              child: Icon(
                _obscurePass.value
                    ? Icons.visibility_off_sharp
                    : Icons.visibility_sharp,
              ),
            ),
          ),
        );
      },
    );
  }

  ValueListenableBuilder<bool> confirmPassword() {
    return ValueListenableBuilder(
      valueListenable: _obscureConfirmPass,
      builder: (context, value, child) {
        return TextField(
          controller: _confirmPasswordController,
          obscureText: value,
          obscuringCharacter: '#', // Password secured by showing -> #######
          focusNode: _confirmPasswordFocusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            filled: true,
            fillColor: AppColours.blackColour1.withOpacity(0.85),
            hintText: "Confirm Password",
            prefixIcon: const Icon(Icons.lock_open_sharp),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColours.greyColour,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            suffixIcon: InkWell(
              onTap: () {
                _obscureConfirmPass.value = !_obscurePass.value;
              },
              child: Icon(
                _obscureConfirmPass.value
                    ? Icons.visibility_off_sharp
                    : Icons.visibility_sharp,
              ),
            ),
          ),
        );
      },
    );
  }

  Center acceptTerms() {
    return Center(
      child: CheckboxListTile(
        title: const Text(
          "Accept Terms", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),),
        value: _acceptTerms,
        onChanged: (bool? value){
          setState(() {
            _acceptTerms = value!;
          });
        },
      ),
    );
  }

}