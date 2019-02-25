import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType {
  login,
  register,
  forget,
  reset
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async{
    if(validateAndSave()){
      try {
        if(_formType == FormType.login) {
          FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          print('Signed in: ${user.uid}');
        } else if (_formType == FormType.register) {
          FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          print('Registered user: ${user.uid}');
        } else if(_formType == FormType.forget){
          return FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        }
      }
      catch(e){
        print('Error $e');
      }
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.login;
    });
  }

  void moveToForget(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.forget;
    });
  }

  void moveToReset(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.reset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter login demo'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs(){
    if(_formType == FormType.login) {
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
      ];
    } else if (_formType == FormType.register){
      final _myPassController = TextEditingController();
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        new TextFormField(
          controller: _myPassController,
          decoration: new InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Retype Password'),
          obscureText: true,
          validator: (value) => value != _myPassController.text ? 'Retype password' : null,
          onSaved: (value) => _password = value,
        ),
      ];
    } else if (_formType == FormType.forget){
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
      ];
    } else if (_formType == FormType.reset) {
      final _myPassController = TextEditingController();
      return [
        new TextFormField(
          controller: _myPassController,
          decoration: new InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Retype Password'),
          obscureText: true,
          validator: (value) => value != _myPassController.text ? 'Retype password' : null,
          onSaved: (value) => _password = value,
        ),
      ];
    }
  }

  List <Widget> buildSubmitButtons(){
    if(_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton (
          child: new Text('Forgot Password?', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToForget,
        ),
        new FlatButton (
        child: new
          Text('Create an account', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToRegister,
        ),
      ];
    } else if (_formType == FormType.register){
      return [
        new RaisedButton(
          child: new Text('Create an Account', style: new TextStyle(fontSize: 20.0)),
          onPressed: () {
            if(validateAndSave()){
              validateAndSubmit();
              moveToLogin();
            }
          },
        ),
        new FlatButton (
        child: new Text('Have an account? Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),

      ];
    } else if (_formType == FormType.forget){
      return [
        new RaisedButton(
        child: new Text('Send Email', style: new TextStyle(fontSize: 20.0)),
        onPressed: () {
          validateAndSubmit();
          return showDialog (
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                    'If email exists, we will send an email with a link to reset your password'),
              );
            },
          );
        }

       ),
        new FlatButton (
          child: new Text('Go Back to Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
      ];
    } else if (_formType == FormType.reset){
      return [
        new RaisedButton(
          child: new Text('Reset Password', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
        new FlatButton(
          child: new Text('Go Back to Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}