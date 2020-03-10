import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:pathole_detection/LoginScreen/auth_service.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import '../HomeController.dart';
final primaryColor = const Color(0xFF75A2EA);
enum AuthFormType {signIn, signUp}
class SignUpView extends StatefulWidget{
  final AuthFormType authFormType;
  SignUpView({Key key, Widget child, this.authFormType}) : super(key:key);
  @override
  _SignUpViewState createState() =>_SignUpViewState(authFormType: this.authFormType);
  }

  class _SignUpViewState extends State<SignUpView>{
  AuthFormType authFormType;
  _SignUpViewState({this.authFormType});
    final formKey = GlobalKey<FormState>();
    String _email, _password,_name, _error;

    void switchFormState(String state){
      formKey.currentState.reset();
      if(state == 'signUp'){
        setState(() {
          authFormType = AuthFormType.signUp;
        });
      }else{
        setState(() {
          authFormType= AuthFormType.signIn;
        });
      }
    }

    bool validate(){
      final form = formKey.currentState;
      form.save();
      if(form.validate()){
        form.save();
        return true;
      }else{
        return false;
      }
    }

    void submit() async {
      if (validate()) {
        try {
          final auth = Provider
              .of(context)
              .auth;
          if (authFormType == AuthFormType.signIn) {
            String uid = await auth.signInWithEmailAndPassword(
                _email, _password);
            print("Signed In with ID $uid");
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            String uid = await auth.createUserWithEmailAndPassword(
                _email, _password, _name);
            print("Signed Up with New ID $uid");
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } catch (e) {
          print(e);
          setState(() {
            _error = e.message;
          });
        }
      }
    }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: Container(
        color: primaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            showAlert(),
            SizedBox(height: 20,),
            buildHeaderText(),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: buildInputs() + buildButtons(),
                ),
              ),
            ),
            buildSocialIcons()
          ],
        )),
      ),
    );
  }

  Widget showAlert(){
      if(_error != null){
        return Container(
          color: Colors.amberAccent,
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.error),
              ),
              Expanded(child: AutoSizeText(_error , maxLines: 3,),),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: (){
                    setState(() {
                      _error =null;
                    });
                  }
              )
            ],
          ),
        );
      }
      return SizedBox(height: 8,);
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if(authFormType == AuthFormType.signUp){
      _headerText = "Create New Account";
    }else{
      _headerText = "Sign In";
    }
    return AutoSizeText(_headerText,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            color: Colors.white
          ),);
  }
  List<Widget> buildInputs(){
    List<Widget> textFields = [];

    //if were in the sign up state add name
    if(authFormType == AuthFormType.signUp){
      textFields.add(
        TextFormField(
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: InputDecoration(
            hintText: "Name",
            filled: true,
            fillColor: Colors.white,
            focusColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 0.0)),
            contentPadding: const EdgeInsets.only(left: 14,bottom: 10,top: 10),
          ),
          onSaved:(value) => _name= value ,
        ),
      );
      textFields.add(SizedBox(height: 20,));
    }

    // add email & password
    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: InputDecoration(
          hintText: "Email",
          filled: true,
          fillColor: Colors.white,
          focusColor: Colors.white,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 0.0)),
          contentPadding: const EdgeInsets.only(left: 14,bottom: 10,top: 10),
        ),
        onSaved:(value) => _email = value ,
      ),


    );
    textFields.add(SizedBox(height: 20,));
    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: InputDecoration(
          hintText: "Password",

          filled: true,
          fillColor: Colors.white,
          focusColor: Colors.white,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 0.0)),
          contentPadding: const EdgeInsets.only(left: 14,bottom: 10,top: 10),
        ),
        obscureText: true,
        onSaved:(value) => _password = value ,
      ),
    );
    textFields.add(SizedBox(height: 20,));
    return textFields;
  }

  List<Widget> buildButtons(){
      String _switchButtonText , _newFormState, _submitButtonText;

      if(authFormType == AuthFormType.signIn){
        _switchButtonText = "Create New Account";
        _newFormState ="signUp";
        _submitButtonText = "Sign In";
      } else{
        _switchButtonText = "Have an Account? Sign In";
        _newFormState = "signIn";
        _submitButtonText = "Sign Up";
      }
      
      return[

        Container(
          width: MediaQuery.of(context).size.width *0.7,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)
            ),
            color: Colors.white,
            textColor: primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_submitButtonText, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),),
            ),
            onPressed: submit,
          ),
        ),

        FlatButton(
          child: Text(_switchButtonText , style: TextStyle(color: Colors.white),),
          onPressed: (){
            switchFormState(_newFormState);
          },
        )
      ];
  }


  Widget buildSocialIcons(){

      return Column(
        children: <Widget>[
          Divider(color: Colors.white,),
          SizedBox(height: 10,),
          GoogleSignInButton(
            onPressed: () async{
              try{
                final _auth = Provider
                    .of(context)
                    .auth;
                await _auth.signInwithGoogle();
               Navigator.of(context).pushReplacementNamed('/home');
              }catch(e){
                setState(() {
                  _error = e.message;
                });
              }
            },
          )
        ],
      );
  }

}