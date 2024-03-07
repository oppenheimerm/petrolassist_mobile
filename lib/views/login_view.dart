import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_constants.dart';
import '../components/component_bkgrd_img.dart';
import '../components/component_checkCircle_icon.dart';
import '../components/component_frosted_glass.dart';
import '../components/component_headline_text.dart';
import '../components/component_round_button.dart';
import '../resources/colours.dart';
import '../utilities/utils.dart';
import '../view_models/auth_vm.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //  When value is replaced with something that is not equal to the old
  //  value as evaluated by the equality operator ==, this class notifies
  //  its listeners.
  //
  //  Because this class only notifies listeners when the value's identity
  //  changes, listeners will not be notified when mutable state within
  //  the value itself changes. As a result *** best used with only
  //  immutable data types. ***
  //
  //  https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html
  final ValueNotifier<bool> _obscurePass = ValueNotifier<bool>(true);

  //  FocusNode - used by a stateful widget to obtain the keyboard focus
  //  and to handle keyboard events.
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //  Use trim() method removes any leading / trailing  from user input before
  //  using it in the application
  /*Map<String, dynamic> getUserCredentials() {
    return {
      "email": _emailController.text.trim().toString(),
      "password": _passwordController.text.trim().toString(),
    };
  }*/

  //  By properly disposing of resources and unregistering event listeners, you
  //  ensure that your app is efficient and responsive, even as widgets are created
  //  and destroyed
    @override
    void dispose() {
      _emailController.dispose();
      _passwordController.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
      _obscurePass.dispose();
      super.dispose();
    }

    double getContextHeight(BuildContext context){
      return MediaQuery.of(context).size.height;
    }

  double getContextWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;


    //  Validate our text fields
    void textFieldValidate() async {
      if (_emailController.text.isEmpty) {
        Utils.snackBar("Email can't be empty!", context);
      } else if (!_emailController.text.contains("@")) {
        Utils.snackBar("Email must contain @", context);
      } else if (_passwordController.text.isEmpty) {
        Utils.snackBar("Password can't be empty!", context);
      } else if (_passwordController.text.length < 6) {
        Utils.snackBar("Password must be more than 6 letter's", context);
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

    return PopScope(

      //  When false, blocks the current route from being popped.
      //  https://api.flutter.dev/flutter/widgets/PopScope/canPop.html
      //// Android User's can simply exit from app by pressing back button
      canPop: true,
        child: Scaffold(
          body: Stack(
            children: [
              const BackgroundImage(imageUrl: "assets/images/bg_1.jpg", fit: BoxFit.cover),
          FrostedGlassBox(
            height: height * .7,
            width: width < 450 ? double.infinity : 480,
            child: login(height, textFieldValidate, context),
          ),
            ],
          ),
        ),
    );
  }

  Padding login(
      double height,
      void Function() textFieldValidate, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CheckCircleIcon(),
          SizedBox(height: height * .03),
          const Headline(title: "PetrolAssist", colour: AppColours.blackColour1,),
          SizedBox(height: height * .04),
          email(),
          SizedBox(height: height * .02),
          password(),
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
          buildSignUpQueryOption(context),
        ],
      ),
    );
  }
  Widget buildSignUpQueryOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
            color: AppColours.transparentColour,
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppConsts.rootSignup);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors
                .click, // Icon changed when user hover over the container
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Sign up",
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
            prefixIcon: const Icon(Icons.lock_sharp),
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
            current: _emailFocusNode, next: _passwordFocusNode);
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
        prefixIcon: const Icon(Icons.email_sharp),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

}
