import 'package:flutter/material.dart';
import '../../providers/motivation_provider.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final MotivationProvider _provider = MotivationProvider();

  @override
  void initState() {
    super.initState();
    _provider.loadMotivations();
    _provider.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Motivations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _provider.error != null
              ? Center(child: Text('Error: ${_provider.error}'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _provider.motivations.length,
                  itemBuilder: (context, index) {
                    final motivation = _provider.motivations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"${motivation.quote}"',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '— ${motivation.author}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
