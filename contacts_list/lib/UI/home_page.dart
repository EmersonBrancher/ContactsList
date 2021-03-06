import 'dart:io';

import 'package:contacts_list/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    /*Contact c = Contact();
    c.name = "Kleber Brancher";
    c.email = "kleber.brancher@teste.com";
    c.phone = "(XX) 54321-1234";
    c.img = "Imagem Aqui também";
    helper.saveContact(c);*/
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text ("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        }
      ),
    );
  }

  Widget _contactCard (BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null ?
                      FileImage(File(contacts[index].img)) :
                      AssetImage("images/person.png")
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(contacts[index].name ?? "",
                          style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                        ),
                        Text(contacts[index].email ?? "",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Text(contacts[index].phone ?? "",
                          style: TextStyle(fontSize: 18.0),
                        )
                      ],
                    ),)
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

   void _showOptions (BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
          onClosing: (){},
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(onPressed: () {
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                          child: Text("Ligar", style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                          child: Text("Editar", style: TextStyle(color: Colors.red, fontSize: 20.0)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(onPressed: () {
                          helper.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                          child: Text("Excluir", style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                        ),
                      )
                    ],
                  ),
                );
          }
          );
        }
    );
  }

  void _showContactPage({Contact contact}) async {
    
    final recContact = await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
    if (recContact != null) {
      if(contact != null){
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      // print(list);
      setState(() {
        contacts = list;
      });
    });
  }
}
