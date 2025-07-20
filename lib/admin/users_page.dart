import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  List<Map<String, dynamic>> users = [
    {
      "name": "John David",
      "email": "john@gmail.com",
      "avatar": "assets/david.jpg",
      "roleDescription":
          "John, the visionary CEO, stands as the driving force behind our company's pursuit of excellence and innovation."
    },
    {
      "name": "Bob Smith",
      "email": "bob@gmail.com",
      "avatar": "assets/bob.jpg",
      "roleDescription":
          "Bob, our inspiring CEO, serves as the backbone of leadership and growth, shaping the future of the organization."
    },
  ];

  void _showUserDetails(int index) {
    final user = users[index];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(user['avatar']),
              ),
              const SizedBox(height: 16),
              Text(
                user['name'],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                user['email'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                user['roleDescription'],
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    users.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete User"),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addNewUser() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final avatarController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add New Admin"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: avatarController,
                  decoration: const InputDecoration(
                    labelText: "Avatar path (e.g. assets/avatar.jpg)",
                  ),
                ),
                TextField(
                  controller: roleController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Role Description",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  setState(() {
                    users.add({
                      "name": nameController.text,
                      "email": emailController.text,
                      "avatar": avatarController.text.isNotEmpty
                          ? avatarController.text
                          : "assets/default_avatar.png", // fallback
                      "roleDescription":
                          roleController.text.isNotEmpty
                              ? roleController.text
                              : "Admin role description.",
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewUser,
        icon: const Icon(Icons.add),
        label: const Text("Add Admin"),
      ),
      body: users.isEmpty
          ? const Center(child: Text("No users available"))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user['avatar']),
                    radius: 25,
                  ),
                  title: Text(user['name'],
                      style: theme.textTheme.titleMedium),
                  subtitle: Text(user['email']),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.blue),
                    onPressed: () => _showUserDetails(index),
                  ),
                );
              },
            ),
    );
  }
}
