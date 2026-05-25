// ignore_for_file: deprecated_member_use

import 'package:app/functions/api.dart';
import 'package:app/functions/colors.dart';
import 'package:flutter/material.dart';

class AIChatBottomSheet extends StatefulWidget {
  const AIChatBottomSheet({Key? key}) : super(key: key);

  @override
  State<AIChatBottomSheet> createState() => AIChatBottomSheetState();
}

class AIChatBottomSheetState extends State<AIChatBottomSheet>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isThinking = false;
  late AnimationController _dotController;

  final List<Map<String, String>> _suggestedTopics = [
    {'label': 'Position', 'icon': '\uf0b1'},
    {'label': 'Salary', 'icon': '\uf155'},
    {'label': 'Province', 'icon': '\uf5a0'},
    {'label': 'Language', 'icon': '\uf1ab'},
    {'label': 'Company', 'icon': '\uf1ad'},
    {'label': 'Experience', 'icon': '\uf19d'},
    {'label': 'Education Level', 'icon': '\uf549'},
  ];

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    _messages.add({
      'role': 'ai',
      'text':
          'Hello! 👋 I can help you find the right job.\nWhat would you like to search for?',
    });
  }

  @override
  void dispose() {
    _dotController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final userText = text.trim();
    setState(() {
      _messages.add({'role': 'user', 'text': userText});
      _inputController.clear();
      _isThinking = true;
    });
    _scrollToBottom();

    try {
      var res = await postData(askAIJobSearchApi, {'message': userText});
      final String reply =
          res['reply'] ?? res['message'] ?? 'Here are some matching jobs!';
      setState(() {
        _isThinking = false;
        _messages.add({'role': 'ai', 'text': reply});
      });
    } catch (_) {
      setState(() {
        _isThinking = false;
        _messages.add({
          'role': 'ai',
          'text': 'Sorry, something went wrong. Please try again.',
        });
      });
    }
    _scrollToBottom();
  }

  Widget _buildThinkingDots() {
    return AnimatedBuilder(
      animation: _dotController,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final value =
                ((_dotController.value - delay) % 1.0).clamp(0.0, 1.0);
            final opacity =
                (value < 0.5 ? value * 2 : (1 - value) * 2).clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: AppColors.primaryCustom.withOpacity(opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final bool isUser = msg['role'] == 'user';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryCustom, const Color(0xFF00AAFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/image/ai.png',
                  width: 14,
                  height: 14,
                  fit: BoxFit.contain,
                  color: AppColors.iconLight,
                ),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primaryCustom
                    : AppColors.backgroundWhite,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser
                    ? null
                    : Border.all(color: AppColors.borderSecondary),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                msg['text'] ?? '',
                style: TextStyle(
                  color: isUser ? Colors.white : AppColors.fontDark,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 36),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showChips = _messages.length <= 1;
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(bottom: 40),
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            // Container(
            //   margin: const EdgeInsets.only(top: 12),
            //   width: 40,
            //   height: 4,
            //   decoration: BoxDecoration(
            //     color: AppColors.borderSecondary,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            // ),
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                border: Border(
                  bottom: BorderSide(color: AppColors.borderSecondary),
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ask Job Search Assistant',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.fontDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close,
                          size: 18, color: AppColors.fontDark),
                    ),
                  ),
                ],
              ),
            ),
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length +
                    (_isThinking ? 1 : 0) +
                    (showChips ? 1 : 0),
                itemBuilder: (context, index) {
                  // Suggested chips row
                  if (showChips && index == _messages.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _suggestedTopics.map((topic) {
                          return GestureDetector(
                            onTap: () => _sendMessage(topic['label']!),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundWhite,
                                border: Border.all(
                                    color: AppColors.primaryCustom
                                        .withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    topic['label']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primaryCustom,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  // Thinking dots
                  if (_isThinking &&
                      index == _messages.length + (showChips ? 1 : 0)) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            margin: const EdgeInsets.only(right: 8, bottom: 2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryCustom,
                                  const Color(0xFF00AAFF)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/image/ai.png',
                                width: 14,
                                height: 14,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundWhite,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                                bottomLeft: Radius.circular(4),
                              ),
                              border:
                                  Border.all(color: AppColors.borderSecondary),
                            ),
                            child: _buildThinkingDots(),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            // Input area
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                border: Border(
                  top: BorderSide(color: AppColors.borderSecondary),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.borderSecondary),
                      ),
                      child: TextField(
                        controller: _inputController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _sendMessage,
                        maxLines: 3,
                        minLines: 1,
                        style:
                            TextStyle(fontSize: 14, color: AppColors.fontDark),
                        decoration: InputDecoration(
                          hintText: 'Ask about jobs...',
                          hintStyle: TextStyle(
                              color: AppColors.fontGreyOpacity, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _sendMessage(_inputController.text),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryCustom,
                            const Color(0xFF00AAFF)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: AppColors.primaryCustom.withOpacity(0.35),
                        //     blurRadius: 8,
                        //     offset: const Offset(0, 3),
                        //   ),
                        // ],
                      ),
                      child: const Center(
                        child: Icon(Icons.send_rounded,
                            color: Colors.white, size: 18),
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
}
