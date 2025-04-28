import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../services/itinerary_service.dart';
import '../models/itinerary.dart';

class ItineraryScreen extends StatefulWidget {
  @override
  _ItineraryScreenState createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final ItineraryService _itineraryService = ItineraryService();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _daysController = TextEditingController(
    text: '3',
  );

  Itinerary? _generatedItinerary;
  bool _isGeneratingItinerary = false;
  String _errorMessage = '';
  String? _shareableLink;

  Future<void> _generateShareableLink() async {
    if (_generatedItinerary == null) return;

    try {
      final link = await _itineraryService.generateShareableLink(
        _generatedItinerary!,
      );
      setState(() {
        _shareableLink = link;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate shareable link')),
      );
    }
  }

  Future<void> _downloadPDF() async {
    if (_generatedItinerary == null) return;

    try {
      final pdf = pw.Document();

      // Add title page
      pdf.addPage(
        pw.Page(
          build:
              (pw.Context context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${_generatedItinerary!.days}-Day Itinerary',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Destination: ${_generatedItinerary!.destination}',
                    style: pw.TextStyle(fontSize: 18),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Generated on: ${DateTime.now().toString().split(' ')[0]}',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
        ),
      );

      // Add content pages
      final content = _generatedItinerary!.content.split('\n');
      final chunks = _chunkContent(content, 30); // 30 lines per page

      for (final chunk in chunks) {
        pdf.addPage(
          pw.Page(
            build:
                (pw.Context context) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: chunk.map((line) => pw.Text(line)).toList(),
                ),
          ),
        );
      }

      // Get downloads directory
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        downloadsDir = await getApplicationDocumentsDirectory();
      } else {
        downloadsDir = await getDownloadsDirectory();
      }

      if (downloadsDir == null) {
        throw Exception('Could not access downloads directory');
      }

      // Create filename with timestamp to avoid overwriting
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename =
          'itinerary_${_generatedItinerary!.destination.replaceAll(' ', '_')}_$timestamp.pdf';
      final file = File('${downloadsDir.path}/$filename');

      // Save the PDF
      await file.writeAsBytes(await pdf.save());

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved to: ${file.path}'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              // You might want to add a PDF viewer here
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to generate PDF: $e')));
    }
  }

  List<List<String>> _chunkContent(List<String> content, int chunkSize) {
    List<List<String>> chunks = [];
    for (var i = 0; i < content.length; i += chunkSize) {
      chunks.add(
        content.sublist(
          i,
          i + chunkSize > content.length ? content.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Itinerary Builder')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Itinerary Generator Section
            Text(
              'Generate Itinerary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),

            // Destination Input
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                hintText: 'Enter a city, region or country',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 15),

            // Days Input
            TextField(
              controller: _daysController,
              decoration: InputDecoration(
                labelText: 'Number of Days',
                hintText: '1-14 days',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // Generate Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isGeneratingItinerary ? null : _generateItinerary,
                child:
                    _isGeneratingItinerary
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('Generating...'),
                          ],
                        )
                        : Text('Generate Itinerary'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            if (_errorMessage.isNotEmpty && !_isGeneratingItinerary)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
              ),

            // Generated Itinerary Display
            if (_generatedItinerary != null) ...[
              SizedBox(height: 30),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        '${_generatedItinerary!.days}-Day Itinerary for ${_generatedItinerary!.destination}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: MarkdownBody(
                        data: _generatedItinerary!.content,
                        selectable: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.share),
                            label: Text('Share'),
                            onPressed: () async {
                              if (_shareableLink == null) {
                                await _generateShareableLink();
                              }
                              if (_shareableLink != null) {
                                await Share.share(_shareableLink!);
                              }
                            },
                          ),
                          SizedBox(width: 8),
                          TextButton.icon(
                            icon: Icon(Icons.save),
                            label: Text('Save PDF'),
                            onPressed: _downloadPDF,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _generateItinerary() async {
    // Validate inputs
    final destination = _destinationController.text.trim();
    if (destination.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a destination';
      });
      return;
    }

    int days;
    try {
      days = int.parse(_daysController.text.trim());
      if (days < 1 || days > 14) {
        setState(() {
          _errorMessage = 'Days must be between 1 and 14';
        });
        return;
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Please enter a valid number of days';
      });
      return;
    }

    // Call API
    setState(() {
      _isGeneratingItinerary = true;
      _errorMessage = '';
    });

    try {
      final itineraryData = await _itineraryService.generateItinerary(
        destination,
        days,
      );
      setState(() {
        _generatedItinerary = Itinerary.fromJson(itineraryData);
        _isGeneratingItinerary = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to generate itinerary. Please try again.';
        _isGeneratingItinerary = false;
      });
    }
  }
}
