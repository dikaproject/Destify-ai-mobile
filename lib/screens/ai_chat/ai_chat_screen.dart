import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AIChatScreen extends StatefulWidget { // Changed to StatefulWidget
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmit(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessage(message: text, isAI: false));
      _messages.insert(0, ChatMessage(
        message: "Fitur dalam tahap pengembangan versi 1.0 Destify AI. "
            "harap menunggu developer menyelesaikan. "
            "Project Develop by Rasya Dika Pratama - SMK Telkom Purwokerto",
        isAI: true,
      ));
    });
    _textController.clear();
  }

  Future<void> _handleImageUpload(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _messages.insert(0, ChatMessage(
            message: "🖼️ Image uploaded: ${image.path.split('/').last}",
            isAI: false,
            image: File(image.path),
          ));
          _messages.insert(0, ChatMessage(
            message: "Fitur dalam tahap pengembangan versi 1.0 Destify AI. "
                "harap menunggu developer menyelesaikan. "
                "Project Develop by Rasya Dika Pratama - SMK Telkom Purwokerto",
            isAI: true,
          ));
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _handleImageUpload(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _handleImageUpload(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar and Tips Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Destify AI Assistant',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Online • Ready to help',
                              style: TextStyle(
                                color: Colors.green[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fadeIn().slideY(),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tips_and_updates,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Try asking about destinations, activities, or travel tips!',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 200.ms).fadeIn().slideX(),
                ],
              ),
            ),

            // Updated Chat Messages Area
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                reverse: true, // Changed to true for better UX
                itemCount: _messages.isEmpty ? 1 : _messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    // Welcome message at the bottom
                    return Column(
                      children: [
                        const SizedBox(height: 8),
                        const ChatBubble(
                          message: "👋 Hi! I'm your AI travel assistant. I can help you:\n\n"
                              "• Find destinations based on your preferences\n"
                              "• Create travel itineraries\n"
                              "• Suggest local activities and attractions\n"
                              "• Provide travel tips and information\n\n"
                              "What would you like to explore today?",
                          isAI: true,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 48,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildSuggestionPill(context, 'Best time to visit Bali'),
                              _buildSuggestionPill(context, 'Hidden gems in Jakarta'),
                              _buildSuggestionPill(context, 'Weekend getaway ideas'),
                              _buildSuggestionPill(context, 'Family-friendly places'),
                            ],
                          ),
                        ),
                      ],
                    ).animate().fadeIn().slideY();
                  }
                  return ChatBubble(
                    message: _messages[index].message,
                    isAI: _messages[index].isAI,
                    image: _messages[index].image,
                  ).animate().fadeIn().scale();
                },
              ),
            ),

            // Updated Input Area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.mood,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              // This will directly show system emoji keyboard
                              _textController.value = TextEditingValue(
                                text: _textController.text + '😀',
                                selection: TextSelection.collapsed(
                                  offset: _textController.text.length + 2,
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              minLines: 1,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline, // Added this
                              textCapitalization: TextCapitalization.sentences, // Added this
                              enableSuggestions: true,
                              decoration: InputDecoration(
                                hintText: 'Ask me anything about travel...',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                              ),
                              onSubmitted: _handleSubmit,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.image,
                              color: Colors.grey[600],
                            ),
                            onPressed: _showImageOptions,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _handleSubmit(_textController.text),
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionPill(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        onPressed: () {},
      ),
    ).animate(delay: 300.ms).fadeIn().scale();
  }
}

// New ChatMessage class
class ChatMessage {
  final String message;
  final bool isAI;
  final File? image; // Added image property

  ChatMessage({
    required this.message,
    required this.isAI,
    this.image,
  });
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isAI;
  final File? image;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isAI,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isAI
                ? Colors.grey[100]
                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Text(
                message,
                style: TextStyle(
                  color: isAI ? Colors.black87 : Theme.of(context).colorScheme.primary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}