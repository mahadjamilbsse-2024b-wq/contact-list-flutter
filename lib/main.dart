import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Contact',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ContactListScreen(),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  // Master Contact List Dataset (Updated with your requested names)
  final List<Map<String, String>> _allContacts = [
    {'name': 'Mahad', 'phone': '+92 300 1234567', 'role': 'Flutter UI Expert'},
    {'name': 'Jamil', 'phone': '+92 312 9876543', 'role': 'UX/UI Designer'},
    {'name': 'Umar', 'phone': '+92 333 4567890', 'role': 'Backend Engineer'},
    {'name': 'Ahmad', 'phone': '+92 345 5551234', 'role': 'Project Manager'},
    {'name': 'Moiz', 'phone': '+92 321 7778899', 'role': 'DevOps Specialist'},
    {'name': 'Abdullah', 'phone': '+92 301 4443322', 'role': 'QA Engineer'},
    {'name': 'Yamaan', 'phone': '+92 315 8889900', 'role': 'Data Analyst'},
    {'name': 'Ali', 'phone': '+92 322 1112233', 'role': 'Security Analyst'},
    {'name': 'Waqar', 'phone': '+92 346 6665544', 'role': 'Cloud Engineer'},
  ];

  // Lists for handling dynamic live search filtering
  List<Map<String, String>> _foundContacts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _foundContacts = _allContacts; // Initially show all items
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Feature 1: Live Search Functionality
  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allContacts;
    } else {
      results = _allContacts
          .where((user) => user['name']!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundContacts = results;
    });
  }

  // Feature 2: Add and Save New Contact Dialog
  void _addNewContactDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Contact'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role/Job Title'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty && phoneController.text.trim().isNotEmpty) {
                setState(() {
                  _allContacts.add({
                    'name': nameController.text.trim(),
                    'phone': phoneController.text.trim(),
                    'role': roleController.text.trim().isEmpty ? 'Contact' : roleController.text.trim(),
                  });
                  _runFilter(_searchController.text); // Sync view dataset update
                });
                Navigator.pop(ctx);
                _showSnackBar('Contact Saved Successfully!', Colors.green);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Feature 3: Edit Contact Name Dialog
  void _editContactNameDialog(Map<String, String> contact) {
    final TextEditingController editNameController = TextEditingController(text: contact['name']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Contact Name'),
        content: TextField(
          controller: editNameController,
          decoration: const InputDecoration(labelText: 'Update Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (editNameController.text.trim().isNotEmpty) {
                int masterIndex = _allContacts.indexOf(contact);
                if (masterIndex != -1) {
                  setState(() {
                    _allContacts[masterIndex]['name'] = editNameController.text.trim();
                    _runFilter(_searchController.text); // Refresh searching filters UI stream
                  });
                }
                Navigator.pop(ctx);
                _showSnackBar('Contact Name Updated!', Colors.teal);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Utility feedback notifier snackbar panel setup
  void _showSnackBar(String text, Color bgColor) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Contact'), // Custom requested Title
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Chip(
              backgroundColor: Colors.teal.shade900,
              label: Text(
                'Total: ${_foundContacts.length}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      // Floating button to Add and Save New Contacts
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewContactDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      ),
      body: Column(
        children: [
          // Live Interactive Search Engine Container Layout
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                labelText: 'Search Contact Name...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _runFilter('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          
          // Rendering Context Contact Lists Row Elements
          Expanded(
            child: _foundContacts.isEmpty
                ? const Center(
                    child: Text(
                      'No matching contacts found!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _foundContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _foundContacts[index];
                      final String name = contact['name']!;
                      final String phone = contact['phone']!;
                      final String role = contact['role']!;
                      final String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade100,
                            foregroundColor: Colors.teal.shade800,
                            child: Text(
                              initial,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            '$role\n$phone',
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit Contact Button
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _editContactNameDialog(contact),
                              ),
                              // Message Trigger Button
                              IconButton(
                                icon: const Icon(Icons.message, color: Colors.green),
                                onPressed: () => _showSnackBar('Opening text chat thread with $name...', Colors.green),
                              ),
                              // Call Trigger Button (Added Feature)
                              IconButton(
                                icon: const Icon(Icons.phone, color: Colors.purple),
                                onPressed: () => _showSnackBar('Calling $name ($phone)...', Colors.purple),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}