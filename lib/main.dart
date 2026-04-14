import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ConservationModeApp());
}

class ConservationModeApp extends StatelessWidget {
  const ConservationModeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conservation Mode',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ConservationModePage(),
    );
  }
}

class ConservationModePage extends StatefulWidget {
  const ConservationModePage({super.key});

  @override
  State<ConservationModePage> createState() => _ConservationModePageState();
}

class _ConservationModePageState extends State<ConservationModePage> {
  bool _isConservationModeEnabled = false;
  bool _isLoading = true;
  String _statusMessage = '';
  final String _conservationModePath =
      '/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode';

  @override
  void initState() {
    super.initState();
    _readConservationMode();
  }

  Future<void> _readConservationMode() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Reading current state...';
    });

    try {
      final result = await Process.run(
        'cat',
        [_conservationModePath],
      );

      if (result.exitCode == 0) {
        final value = result.stdout.toString().trim();
        setState(() {
          _isConservationModeEnabled = value == '1';
          _isLoading = false;
          _statusMessage =
              'Current mode: ${_isConservationModeEnabled ? "ON" : "OFF"}';
        });
      } else {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Error reading mode: ${result.stderr}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: $e';
      });
    }
  }

  Future<void> _toggleConservationMode(bool newValue) async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Updating conservation mode...';
    });

    try {
      final value = newValue ? '1' : '0';
      final result = await Process.run(
        'pkexec',
        [
          'sh',
          '-c',
          'echo $value > $_conservationModePath',
        ],
      );

      if (result.exitCode == 0) {
        setState(() {
          _isConservationModeEnabled = newValue;
          _isLoading = false;
          _statusMessage =
              'Current mode: ${_isConservationModeEnabled ? "ON" : "OFF"}';
        });
      } else {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Error: ${result.stderr}';
        });
        // Refresh the state
        await _readConservationMode();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: $e';
      });
      // Refresh the state
      await _readConservationMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Battery Conservation Mode'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.battery_charging_full,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 32),
              const Text(
                'Conservation Mode',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Limits battery charge to 60% to extend battery life',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              // Cupertino style toggle
              Transform.scale(
                scale: 1.5,
                child: CupertinoSwitch(
                  value: _isConservationModeEnabled,
                  activeTrackColor: CupertinoColors.systemGreen,
                  onChanged: _isLoading ? null : _toggleConservationMode,
                ),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Text(
                  _statusMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: _statusMessage.contains('Error')
                        ? Colors.red
                        : Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _readConservationMode,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
