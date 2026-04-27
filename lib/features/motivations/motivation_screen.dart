import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/motivation_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme/theme_notifier.dart';
import '../auth/login_screen.dart';

class MotivationScreen extends StatefulWidget {
  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final provider = context.read<MotivationProvider>();
    provider.fetchMotivations();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        provider.fetchMotivations();
      }
    });
  }

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, HH:mm").format(parsed);
    } catch (e) {
      return date;
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Logout"),
        content: Text("Apakah kamu yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }

  void showGenerateDialog() {
    final themeController = TextEditingController();
    final totalController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<MotivationProvider>(
          builder: (context, provider, _) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text("✨ "),
                  Text("Generate Motivasi"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: themeController,
                    decoration: InputDecoration(
                      labelText: "Theme",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: totalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Total",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: provider.isGenerating
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: provider.isGenerating
                      ? null
                      : () async {
                          final token =
                              context.read<AuthProvider>().token ?? '';
                          try {
                            await provider.generate(
                              themeController.text,
                              int.parse(totalController.text),
                              token,
                            );
                            Navigator.pop(dialogContext);
                          } catch (e) {
                            Navigator.pop(dialogContext);
                            // Jika 401, paksa logout
                            if (e.toString().contains("Sesi habis")) {
                              context.read<AuthProvider>().logout();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LoginScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e
                                      .toString()
                                      .replaceFirst('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: provider.isGenerating
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text("Generating..."),
                          ],
                        )
                      : Text("Generate"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MotivationProvider>();
    final theme = context.watch<ThemeNotifier>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delcom Motivation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: theme.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _handleLogout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showGenerateDialog,
        icon: Icon(Icons.auto_awesome),
        label: Text("Generate"),
        backgroundColor: Color(0xFF6366F1),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 120),
              itemCount: provider.motivations.length + 1,
              itemBuilder: (context, index) {
                if (index < provider.motivations.length) {
                  final item = provider.motivations[index];
                  final number = index + 1;

                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF6366F1),
                          Color(0xFF8B5CF6),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#$number",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatDate(item.createdAt),
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          item.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return provider.isLoading
                      ? Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text("Loading..."),
                            ],
                          ),
                        )
                      : SizedBox();
                }
              },
            ),
          ),
          if (provider.isGenerating)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
