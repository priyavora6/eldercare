import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eldercare/l10n/app_localizations.dart';

class EmergencyContacts extends StatefulWidget {
  @override
  _EmergencyContactsState createState() => _EmergencyContactsState();
}

class _EmergencyContactsState extends State<EmergencyContacts> {
  final List<Contact> _contacts = [
    Contact(
      name: 'John Doe Jr. (Son)',
      phone: '+1 234-567-8900',
      relationship: 'Family',
      isPrimary: true,
      icon: Icons.family_restroom,
    ),
    Contact(
      name: 'Mary Doe (Daughter)',
      phone: '+1 234-567-8901',
      relationship: 'Family',
      isPrimary: false,
      icon: Icons.family_restroom,
    ),
    Contact(
      name: 'Dr. Smith',
      phone: '+1 234-567-8902',
      relationship: 'Doctor',
      isPrimary: false,
      icon: Icons.medical_services,
    ),
    Contact(
      name: 'Ambulance',
      phone: '911',
      relationship: 'Emergency',
      isPrimary: false,
      icon: Icons.local_hospital,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2),
        title: Text(l10n.emergencyContacts, style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return _buildContactCard(_contacts[index], index, l10n);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addContact(context, l10n),
        backgroundColor: Color(0xFF4A90E2),
        icon: Icon(Icons.add, size: 28),
        label: Text(
          l10n.addContact,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildContactCard(Contact contact, int index, AppLocalizations l10n) {
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
                  contact.icon,
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
                            child: Text(
                              l10n.primary,
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
                    Text(
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
                  onPressed: () => _makeCall(contact.phone, l10n),
                  icon: Icon(Icons.phone, size: 24),
                  label: Text(
                    l10n.call,
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
                  onPressed: () => _editContact(context, index, l10n),
                  icon: Icon(Icons.edit, size: 24),
                  label: Text(
                    l10n.edit,
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

  Future<void> _makeCall(String phoneNumber, AppLocalizations l10n) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.couldNotOpenPhoneDialer),
          backgroundColor: Color(0xFFE74C3C),
        ),
      );
    }
  }

  void _addContact(BuildContext context, AppLocalizations l10n) {
    final _nameController = TextEditingController();
    final _phoneController = TextEditingController();
    String _relationship = l10n.family;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addEmergencyContact),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.name,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _relationship,
                decoration: InputDecoration(
                  labelText: l10n.relationship,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
                items: [l10n.family, l10n.doctor, l10n.neighbor, l10n.friend, l10n.emergency]
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
            child: Text(l10n.cancel, style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _phoneController.text.isNotEmpty) {
                setState(() {
                  _contacts.add(Contact(
                    name: _nameController.text,
                    phone: _phoneController.text,
                    relationship: _relationship,
                    isPrimary: false,
                    icon: Icons.person,
                  ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.contactAddedSuccessfully),
                    backgroundColor: Color(0xFF50C878),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2),
            ),
            child: Text(l10n.add, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _editContact(BuildContext context, int index, AppLocalizations l10n) {
    final contact = _contacts[index];
    final _nameController = TextEditingController(text: contact.name);
    final _phoneController = TextEditingController(text: contact.phone);
    String _relationship = contact.relationship;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editContact),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.name,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _relationship,
                decoration: InputDecoration(
                  labelText: l10n.relationship,
                  border: OutlineInputBorder(),
                ),
                items: [l10n.family, l10n.doctor, l10n.neighbor, l10n.friend, l10n.emergency]
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
            onPressed: () {
              setState(() {
                _contacts.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.contactDeleted),
                  backgroundColor: Color(0xFFE74C3C),
                ),
              );
            },
            child: Text(l10n.delete, style: TextStyle(color: Color(0xFFE74C3C))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _contacts[index] = Contact(
                  name: _nameController.text,
                  phone: _phoneController.text,
                  relationship: _relationship,
                  isPrimary: contact.isPrimary,
                  icon: contact.icon,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.contactUpdated),
                  backgroundColor: Color(0xFF50C878),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2),
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

class Contact {
  final String name;
  final String phone;
  final String relationship;
  final bool isPrimary;
  final IconData icon;

  Contact({
    required this.name,
    required this.phone,
    required this.relationship,
    required this.isPrimary,
    required this.icon,
  });
}
