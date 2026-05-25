import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdminChatSupportDialog extends StatefulWidget {
  const AdminChatSupportDialog({Key? key}) : super(key: key);

  @override
  State<AdminChatSupportDialog> createState() => _AdminChatSupportDialogState();
}

class _AdminChatSupportDialogState extends State<AdminChatSupportDialog> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  Map<String, dynamic>? _replyingToMessage;

  // Mock initial chat history matching the screenshot exactly
  final List<Map<String, dynamic>> _messages = [
    {
      "isMe": false,
      "text": "Kern 90% t company br jaiy tax hai",
      "replyTo": "Toto",
      "replyToText": "fb and bidding api cancelInvoice",
      "time": "MON AT 3:34 PM",
    },
    {
      "isMe": true,
      "text": "Sad",
      "time": "MON AT 3:34 PM",
    },
    {
      "isMe": true,
      "text": "fb and bidding\napi cancelInvoice hai del field\nisPayAndPost",
      "time": "10:22 AM",
    },
    {
      "isMe": true,
      "isImage": true,
      "imageUrl": "assets/image/Logo108.png", // fallback beautiful image
      "imageTitle": "Antigravity 2.0",
      "imageSubtitle":
          "สร้าง OS ทั้งระบบใน 12 ชม.\n93 agents ทำงานพร้อมกัน 2.6 พันล้าน tokens",
      "time": "10:22 AM",
      "reactionAvatar": "true",
    }
  ];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _isTyping = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dateTime) {
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;
    final String period = hour >= 12 ? "PM" : "AM";
    final int hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final String minuteStr = minute.toString().padLeft(2, '0');
    return "$hour12:$minuteStr $period";
  }

  void _replyTo(Map<String, dynamic> msg) {
    setState(() {
      _replyingToMessage = msg;
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      final newMsg = {
        "isMe": true,
        "text": text,
        "time": _formatTime(DateTime.now()),
      };
      if (_replyingToMessage != null) {
        newMsg["replyTo"] =
            _replyingToMessage!["isMe"] ? "You" : "Addmin Support";
        newMsg["replyToText"] = _replyingToMessage!["text"] ??
            (_replyingToMessage!["isImage"] == true ? "Sent an image" : "");
        _replyingToMessage = null;
      }
      _messages.add(newMsg);
      _messageController.clear();
    });

    _scrollToBottom();
  }

  void _sendLike() {
    setState(() {
      _messages.add({
        "isMe": true,
        "text": "👍",
        "time": _formatTime(DateTime.now()),
      });
    });
    _scrollToBottom();
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // ==========================================
              // HEADER (Messenger Style)
              // ==========================================
              _buildHeader(context),
              const Divider(color: Colors.black12, height: 1),

              // ==========================================
              // CHAT BODY (Message List)
              // ==========================================
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _buildMessageItem(msg);
                  },
                ),
              ),

              // ==========================================
              // REPLY PREVIEW BAR (If active)
              // ==========================================
              if (_replyingToMessage != null) _buildReplyingToPreviewBar(),

              // ==========================================
              // BOTTOM BAR (Input and Attachments)
              // ==========================================
              _buildBottomInputBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyingToPreviewBar() {
    if (_replyingToMessage == null) return const SizedBox.shrink();
    final bool isMe = _replyingToMessage!["isMe"] ?? false;
    final String senderName = isMe ? "You" : "Addmin Support";
    final String text = _replyingToMessage!["text"] ??
        (_replyingToMessage!["isImage"] == true ? "Sent an image" : "");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F8FA),
        border: Border(
          top: BorderSide(color: Colors.black12, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.reply, color: Color(0xFF0078FF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Replying to $senderName",
                  style: bodyTextMiniSmall(
                      null, const Color(0xFF0078FF), FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: bodyTextMiniSmall(null, Colors.black54, null),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black45, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                _replyingToMessage = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          // Back button (Messenger blue)
          IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color(0xFF0078FF), size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),

          // Name
          Expanded(
            child: Text(
              "Addmin Support",
              style: bodyTextNormal(null, AppColors.fontDark, FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> msg) {
    final bool isMe = msg["isMe"] ?? false;
    final bool isImage = msg["isImage"] ?? false;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Display Timestamp separator if available
        if (msg["time"] != null && !_messages.indexOf(msg).isEven)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                msg["time"].toString().toUpperCase(),
                style: bodyTextMiniSmall(null, Colors.black38, FontWeight.bold),
              ),
            ),
          ),

        // Message bubble row
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF0078FF),
                child: Icon(Icons.support_agent, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Reply Preview Block (Optimized with max width and Expanded to prevent overflow)
                  if (msg["replyTo"] != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      constraints: const BoxConstraints(maxWidth: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 3,
                            height: 26,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0078FF),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  msg["replyTo"] == "You"
                                      ? "You"
                                      : "Addmin Support",
                                  style: bodyTextMiniSmall(
                                      null, Colors.black87, FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  msg["replyToText"] ?? "Message",
                                  style: bodyTextMiniSmall(
                                      null, Colors.black54, null),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Actual Bubble content (Wrap in GestureDetector for long press & double tap reply)
                  GestureDetector(
                    onLongPress: () => _replyTo(msg),
                    onDoubleTap: () => _replyTo(msg),
                    child: isImage
                        ? _buildImageMessageBubble(msg)
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(0xFF0078FF)
                                  : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: Radius.circular(isMe ? 20 : 4),
                                bottomRight: Radius.circular(isMe ? 4 : 20),
                              ),
                            ),
                            child: Text(
                              msg["text"],
                              style: bodyTextNormal(
                                  null,
                                  isMe ? Colors.white : AppColors.fontDark,
                                  null),
                            ),
                          ),
                  ),

                  // Beautiful, aligned AM/PM timestamp below bubble
                  if (msg["time"] != null)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2,
                        bottom: 6,
                        left: isMe
                            ? 8
                            : 40, // Match bubble indent bypassing avatar
                        right: isMe ? 8 : 8,
                      ),
                      child: Text(
                        msg["time"],
                        style: bodyTextMiniSmall(null, Colors.black38, null),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        // Read receipt or reaction avatar under the message
        if (msg["reactionAvatar"] != null)
          const Padding(
            padding: EdgeInsets.only(top: 4, right: 4),
            child: CircleAvatar(
              radius: 7,
              backgroundColor: Color(0xFF0078FF),
              child: Icon(Icons.support_agent, size: 8, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildImageMessageBubble(Map<String, dynamic> msg) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image itself
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Stack(
              children: [
                Image.asset(
                  msg["imageUrl"],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          color: Colors.black26, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Color(0xFF0078FF),
                        child:
                            Icon(Icons.person, size: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "AI กับ Peesamac",
                          style: bodyTextMiniSmall(
                              null, Colors.white, FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Title & Details block
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg["imageTitle"] ?? "",
                  style:
                      bodyTextNormal(null, AppColors.fontDark, FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  msg["imageSubtitle"] ?? "",
                  style: bodyTextMiniSmall(null, AppColors.fontGrey, null),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.facebook,
                        color: Color(0xFF0078FF), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "Facebook",
                      style: bodyTextMiniSmall(null, Colors.black38, null),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          // Left action buttons: Plus, Camera, Image, Voice
          _buildActionButton(Icons.file_present, () {
            // Get.snackbar("Add Content", "Pick additional resources to attach");
          }),
          _buildActionButton(Icons.photo_camera, () {
            // Get.snackbar("Camera", "Opening system camera to capture photo");
          }),
          _buildActionButton(Icons.photo, () {
            // Get.snackbar("Gallery", "Opening photo gallery to choose image");
          }),
          _buildActionButton(Icons.mic, () {
            // Get.snackbar(
            //     "Audio Rec", "Press and hold to record a voice message");
          }),

          // Middle message input box
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F5),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: "Message",
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 15),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Right Send / Like button
          GestureDetector(
            onTap: _isTyping ? _sendMessage : _sendLike,
            child: Icon(
              _isTyping ? Icons.send : Icons.thumb_up,
              color: const Color(0xFF0078FF),
              size: 26,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: const Color(0xFF0078FF), size: 24),
        onPressed: onPressed,
      ),
    );
  }
}
