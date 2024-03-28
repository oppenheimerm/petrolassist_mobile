import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_constants.dart';
import '../resources/colours.dart';
import '../resources/spacing_styles.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
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

  /*double getContextHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  double getContextWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }*/

  @override
  Widget build(BuildContext context) {

    //final double height = MediaQuery.of(context).size.height;
    //final width = MediaQuery.of(context).size.width;
    final dark = Utils.isDarkMode(context);

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

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: PASpacingStyles.paddingWithAppbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: PAAppStylesConstants.spaceBetweenSections),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      height: 140,
                      image: AssetImage( dark ? AppConsts.appLogoLightMode : AppConsts.appLogoDarkMode),
                    ),
                    const SizedBox(height: PAAppStylesConstants.sm,),
                    Text(PATextString.loginTitle, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: PAAppStylesConstants.sm,),
                    Text(PATextString.loginSubtitle, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: PAAppStylesConstants.sm,),
                    const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),
                  ],
                ),

                // Form
                Form(
                    child: Column(
                      children: [
                        email(),
                        const SizedBox(height: PAAppStylesConstants.spaceBetweenInputFields,),
                        password(),
                        const SizedBox(height: PAAppStylesConstants.spaceBetweenInputFields / 2,),
                        //  Remember me
                        //  Forgot password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                //  Remember me
                                Checkbox(value: true, onChanged: (value){}),
                                const Text(PATextString.rememberMe),
                              ],
                            ),

                            //  Forgot password
                            //Text(PATextString.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
                            TextButton(onPressed: (){}, child: Text( PATextString.forgotPassword,
                                style: Theme.of(context).textTheme.bodySmall))
                          ],
                        ),

                        const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),

                        // sign in button
                        //  To make this button full with of the form, we need to wrap this widget
                        // a sized box, and set if width to full (infinity)


                        Consumer<AuthViewModel>(
                          builder: (context, value, child){
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  child: const Text(PATextString.login),
                                  onPressed: (){
                                    textFieldValidate();
                                  }),
                            );
                          },
                        ),

                        const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
                        // Create account button
                        SizedBox(
                          //width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, AppConsts.rootRegister);
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: (){
                                  Navigator.pushReplacementNamed(context, AppConsts.rootRegister);
                                }, child: const Text(PATextString.createAccount),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),

                      ],
                    ),
                ),

                //  Divider
                /*Row(
                  //  Center row
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Divider(color: dark ? AppColours.paWhiteColour : AppColours.paGreyColour,
                        thickness: 0.5, indent: 60, endIndent: 5,),
                    )

                  ],
                ),*/

              ],
            ),
          ),
        ),
      ),
    );

  }



  /*Widget buildSignUpQueryOption(BuildContext context) {
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
  }*/

  TextFormField email() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      onFieldSubmitted: ( value ) {
        // After submitting email, click done on keyboard, focus on the password bar
        Utils.changeFocusNode(context,
            current: _emailFocusNode, next: _passwordFocusNode);
      },
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email_sharp),
        labelText: PATextString.emailAddress
      ),
    );
  }

  ValueListenableBuilder<bool>password(){
    return ValueListenableBuilder(
      valueListenable: _obscurePass,
        builder: (context, value, child) {
          return TextFormField(
            focusNode: _passwordFocusNode,
            controller: _passwordController,
            obscureText: value,
            obscuringCharacter: '#', // Password secured by showing -> #######
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_sharp),
                labelText: PATextString.password,
                suffixIcon: InkWell(
                  onTap: (){
                    _obscurePass.value = !_obscurePass.value;
                  },
                  child: Icon(
                    _obscurePass.value
                        ? Icons.visibility_off_sharp
                        : Icons.visibility_sharp,
                  ),
                ),
                hintText: "Password",

            ),
          );
        }
    );
  }


}
