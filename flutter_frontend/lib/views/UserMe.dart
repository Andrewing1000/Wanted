import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserMe extends StatefulWidget {
  @override
  _UserMeState createState() => _UserMeState();
}

class _UserMeState extends State<UserMe> {
  Map<String, dynamic> userData = {
    "email": "",
    "name": "",
    "phone_number": "",
    "is_active": true,
  };

  String token = "your-authentication-token";

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/user/me/'),
        headers: {'Authorization': 'Token $token'},
      );
      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> updateUserData() async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/api/user/me/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos actualizados')),
        );
      } else {
        throw Exception('Actualizacion fallida');
      }
    } catch (error) {
      print('Error al actualizar: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => userData['name'] = value,
              controller: TextEditingController(text: userData['name']),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => userData['email'] = value,
              controller: TextEditingController(text: userData['email']),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              onChanged: (value) => userData['phone_number'] = value,
              controller: TextEditingController(text: userData['phone_number']),
            ),
            SwitchListTile(
              title: Text('Active'),
              value: userData['is_active'] ?? false,
              onChanged: (value) => setState(() {
                userData['is_active'] = value;
              }),
            ),
            ElevatedButton(
              onPressed: updateUserData,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
