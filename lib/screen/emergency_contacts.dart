import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/contact_model.dart';
import '../provider/auth_provider.dart';
import '../provider/language_provider.dart';
import '../services/contact_service.dart';
import '../widgets/translated_text.dart';

class EmergencyContacts extends StatefulWidget {
  @override
  _EmergencyContactsState createState() => _EmergencyContactsState();
}

class _EmergencyContactsState extends State<EmergencyContacts> {
  final ContactService _contactService = ContactService();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.currentUserId;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2),
        title: TranslatedText('Emergency Contacts', style: TextStyle(color: Colors.white)),
      ),
      body: userId == null
          ? Center(child: TranslatedText('Please log in to see your contacts.'))
          : StreamBuilder<List<Contact>>(
              stream: _contactService.getContacts(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: TranslatedText(
                      'No contacts found. Add one to get started!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final contacts = snapshot.data!;

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return _buildContactCard(contacts[index], userId);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => userId != null ? _addContact(context, userId) : null,
        backgroundColor: Color(0xFF4A90E2),
        icon: Icon(Icons.add, size: 28),
        label: TranslatedText(
          'Add Contact',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildContactCard(Contact contact, String userId) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: contact.isPrimary
            ? Border.all(color: Color(0xFF50C878), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF50C878)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForRelationship(contact.relationship),
                  size: 36,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            contact.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ),
                        if (contact.isPrimary)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF50C878),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TranslatedText(
                              'Primary',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      contact.phone,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                    SizedBox(height: 4),
                    TranslatedText(
                      contact.relationship,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makeCall(contact.phone),
                  icon: Icon(Icons.phone, size: 24),
                  label: TranslatedText(
                    'Call',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF50C878),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _editContact(context, contact, userId),
                  icon: Icon(Icons.edit, size: 24),
                  label: TranslatedText(
                    'Edit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF4A90E2),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Color(0xFF4A90E2), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForRelationship(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'family':
        return Icons.family_restroom;
      case 'doctor':
        return Icons.medical_services;
      case 'neighbor':
        return Icons.house;
      case 'friend':
        return Icons.person;
      default:
        return Icons.local_hospital;
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TranslatedText('Could not open phone dialer'),
          backgroundColor: Color(0xFFE74C3C),
        ),
      );
    }
  }

  void _addContact(BuildContext context, String userId) async {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final nameLabel = await langProvider.translate('Name');
    final phoneLabel = await langProvider.translate('Phone Number');
    final relationshipLabel = await langProvider.translate('Relationship');

    final _nameController = TextEditingController();
    final _phoneController = TextEditingController();
    String _relationship = 'Family';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: TranslatedText('Add Emergency Contact'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: nameLabel,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: phoneLabel,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _relationship,
                decoration: InputDecoration(
                  labelText: relationshipLabel,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
                items: ['Family', 'Doctor', 'Neighbor', 'Friend', 'Emergency']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: TranslatedText(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _relationship = newValue;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: TranslatedText('Cancel', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isNotEmpty &&
                  _phoneController.text.isNotEmpty) {
                final newContact = Contact(
                  name: _nameController.text,
                  phone: _phoneController.text,
                  relationship: _relationship,
                );
                await _contactService.addContact(userId, newContact);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: TranslatedText('Contact added successfully'),
                    backgroundColor: Color(0xFF50C878),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2),
            ),
            child: TranslatedText('Add', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _editContact(BuildContext context, Contact contact, String userId) async {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final nameLabel = await langProvider.translate('Name');
    final phoneLabel = await langProvider.translate('Phone Number');
    final relationshipLabel = await langProvider.translate('Relationship');

    final _nameController = TextEditingController(text: contact.name);
    final _phoneController = TextEditingController(text: contact.phone);
    String _relationship = contact.relationship;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: TranslatedText('Edit Contact'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: nameLabel,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: phoneLabel,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _relationship,
                decoration: InputDecoration(
                  labelText: relationshipLabel,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
                items: ['Family', 'Doctor', 'Neighbor', 'Friend', 'Emergency']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: TranslatedText(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _relationship = newValue;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _contactService.deleteContact(userId, contact.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: TranslatedText('Contact deleted'),
                  backgroundColor: Color(0xFFE74C3C),
                ),
              );
            },
            child: TranslatedText('Delete', style: TextStyle(color: Color(0xFFE74C3C))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: TranslatedText('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedContact = Contact(
                id: contact.id,
                name: _nameController.text,
                phone: _phoneController.text,
                relationship: _relationship,
                isPrimary: contact.isPrimary,
              );
              await _contactService.updateContact(userId, updatedContact);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: TranslatedText('Contact updated'),
                  backgroundColor: Color(0xFF50C878),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2),
            ),
            child: TranslatedText('Save'),
          ),
        ],
      ),
    );
  }
}
