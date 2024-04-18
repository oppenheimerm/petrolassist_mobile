import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_constants.dart';
import '../resources/colours.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
import '../utilities/utils.dart';
import '../view_models/auth_vm.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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
  final FocusNode _acceptTermsFocusNode = FocusNode();

  late bool _acceptTerms = false;
  bool formIsValid = false;
  String _errorMessage = "";

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




  /*bool _validatePassword(String password){
    RegExp validatePassword = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{5,}$');
    var valid = validatePassword.hasMatch(password);
    return valid;
  }*/

  bool _validatePassword(String password) {
    // Reset error message


    // Password length greater than 6
    if (password.length <6) {
      _errorMessage += 'Password must be longer than 6 characters.\n';
      formIsValid = false;
    }

    // Contains at least one uppercase letter
    else if (!password.contains(RegExp(r'[A-Z]'))) {
      _errorMessage += '• Uppercase letter is missing.\n';
      formIsValid = false;
    }

    // Contains at least one lowercase letter
    else if (!password.contains(RegExp(r'[a-z]'))) {
      _errorMessage += '• Lowercase letter is missing.\n';
      formIsValid = false;
    }

    // Contains at least one digit
    else if (!password.contains(RegExp(r'[0-9]'))) {
      _errorMessage += '• Digit is missing.\n';
      formIsValid = false;
    }

    // Contains at least one special character
    else if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      _errorMessage += '• One non alpha numeric character is missing.\n';
      formIsValid = false;
    }

    else{
      _errorMessage = "";
      formIsValid = true;
    }

    return formIsValid;

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
    }else if (_passwordController.text.length < AppConsts.minimumPasswordLength) {
      Utils.snackBar("Password must be a minimum of 6 characters.", context);
    }else if(_validatePassword(_passwordController.text) == false){
      Utils.snackBar(_errorMessage, context);
    }
    else if (_passwordController.text.toString() !=
        _confirmPasswordController.text.toString()) {
      Utils.snackBar("Password and confirm password must match.", context);
    }else if(_mobileController.text.isEmpty){
      Utils.snackBar("A valid UK phone number is required.", context);
    }else if(_validateMobileUK(_mobileController.text) == false){
      Utils.snackBar("Please enter a valid UK phone number.", context);
    } else {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final authenticateUserStatus = await authViewModel.registerUser(
        _firstNameController.text.trim().toString(),
          _lastNameController.text.trim().toString(),
          _emailController.text.trim().toString(),
          _passwordController.text.trim().toString(),
        _confirmPasswordController.text.trim().toString(),
        _acceptTerms,
        _mobileController.text.trim().toString(),
      ).then((status) {
        if(context.mounted){
          if(status.success)
          {
            // Navigate to the home screen using the named route.
            Navigator.pushNamed(context, AppConsts.verifyEmail);
          }else{
            var errMsg = status.errorMessage ?? "Could not log in";
            debugPrint(errMsg);
            Utils.snackBar(errMsg, context);
          }
                }
      });
    }
  }



  //  Test version without authentication
  /*void textFieldValidate2() async {
    Navigator.pushNamed(context, AppConsts.verifyEmail);
  }*/


  @override
  Widget build(BuildContext context) {

    final dark = Utils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pushNamed(context, AppConsts.rootLogin);
          }, icon: const Icon(Icons.arrow_back_sharp),
        ),
      ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(PAAppStylesConstants.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( PATextString.createAccount, style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),
          Form(child:
            Column(
              children: [
                buildForm(context, dark),
                // Password
              ],
            ),
          )
        ],
      ),
    ),
    )
    );


  }

  Form buildForm( BuildContext context, bool dark){
    return Form(child:
    Column(
      children: [
        //  Firstname
        TextFormField(
          controller: _firstNameController,
          focusNode: _firstNameFocusNode,
          keyboardType: TextInputType.text,
          expands: false,
          onFieldSubmitted: ( value ) {
            Utils.changeFocusNode(context,
                current: _firstNameFocusNode, next: _lastNameFocusNode);
          },
          decoration: const InputDecoration(
            hintText: PATextString.firstName,
            labelText: PATextString.firstName,
          ),
        ),
        const SizedBox(height: PAAppStylesConstants.spaceBetweenInputFields),
        //Lastname
        TextFormField(
          controller: _lastNameController,
          focusNode: _lastNameFocusNode,
          keyboardType: TextInputType.text,
          expands: false,
          onFieldSubmitted: ( value ) {
            Utils.changeFocusNode(context,
                current: _lastNameFocusNode, next: _emailFocusNode);
          },
          decoration: const InputDecoration(
            hintText: PATextString.lastName,
            labelText: PATextString.lastName,
          ),
        ),
        const SizedBox(height: PAAppStylesConstants.spaceBetweenInputFields),
        //Email
        TextFormField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          expands: false,
          onFieldSubmitted: ( value ) {
            Utils.changeFocusNode(context,
                current: _emailFocusNode, next: _mobileFocusNode);
          },
          decoration: const InputDecoration(
            hintText: PATextString.emailAddress,
            labelText: PATextString.emailAddress,
          ),
        ),
        const SizedBox(height: PAAppStylesConstants.spaceBetweenInputFields),
        //Mobile
        TextFormField(
          controller: _mobileController,
          focusNode: _mobileFocusNode,
          keyboardType: TextInputType.phone,
          expands: false,
          onFieldSubmitted: ( value ) {
            Utils.changeFocusNode(context,
                current: _mobileFocusNode, next: _passwordFocusNode);
          },
          decoration: const InputDecoration(
            hintText: PATextString.mobile,
            labelText: PATextString.mobile,
          ),
        ),
        const SizedBox(height: PAAppStylesConstants.spaceBetweenInputFields),
        // Password
      ValueListenableBuilder(
        valueListenable: _obscurePass,
        builder: (context, value, child) {
          return TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            onFieldSubmitted: ( value ) {
              Utils.changeFocusNode(context,
                  current: _passwordFocusNode, next:_confirmPasswordFocusNode);
            },
            obscureText: value,
            obscuringCharacter: '#', // Password secured by showing -> #######
            expands: false,
            decoration: InputDecoration(
              hintText: PATextString.password,
              prefixIcon: const Icon(Icons.lock_open_sharp),
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
      ),
        const SizedBox(height: PAAppStylesConstants.spaceBetweenInputFields),
        // Confirm password
        ValueListenableBuilder(
          valueListenable: _obscureConfirmPass,
          builder: (context, value, child) {
            return TextFormField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              onFieldSubmitted: ( value ) {
                Utils.changeFocusNode(context,
                    current: _confirmPasswordFocusNode, next:_acceptTermsFocusNode);
              },
              obscureText: value,
              obscuringCharacter: '#', // Password secured by showing -> #######
              expands: false,
              decoration: InputDecoration(
                hintText: PATextString.confirmPassword,
                prefixIcon: const Icon(Icons.lock_open_sharp),
                suffixIcon: InkWell(
                  onTap: () {
                    _obscureConfirmPass.value = !_obscureConfirmPass.value;
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
        ),
        const SizedBox(height: PAAppStylesConstants.spaceBetweenInputFields),
        //  Accept terms
        Center(
          child: CheckboxListTile(
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan( text: PATextString.iAgreeTo, style: Theme.of(context).textTheme.bodySmall),
                  TextSpan( text: PATextString.privacyPolicy, style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? AppColours.paWhiteColour :AppColours.paPrimaryColour,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? AppColours.paPrimaryColour :AppColours.paPrimaryColour,
                  )),
                  TextSpan( text: " & ", style: Theme.of(context).textTheme.bodySmall),
                  TextSpan( text: PATextString.termsOfUse, style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? AppColours.paWhiteColour :AppColours.paPrimaryColour,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? AppColours.paPrimaryColour :AppColours.paPrimaryColour,
                  )),
                ],
              ),
            ),
            value: _acceptTerms,
            onChanged: (bool? value){
              setState(() {
                _acceptTerms = value!;
              });
            },
          ),
        ),
        const SizedBox(height: PAAppStylesConstants.spaceBetweenSections),
        // Button create
      Consumer<AuthViewModel>(
        builder: (context, value, child){
          return SizedBox(
            width: double.infinity, child: ElevatedButton(
            onPressed: (){
              textFieldValidate();
            },
            child: const Text( PATextString.createAccount),
          ),
          );
        }
      ),
      ],
    ),
    );
  }

}
