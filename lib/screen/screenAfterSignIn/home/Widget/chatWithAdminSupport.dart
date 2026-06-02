// ignore_for_file: prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, deprecated_member_use, prefer_final_fields, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:dio/dio.dart' as dio;

import 'package:app/functions/colors.dart';
import 'package:app/functions/api.dart';
import 'package:app/provider/profileProvider.dart';
import 'package:app/functions/sharePreferencesHelper.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/functions/alert_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:app/functions/shimmerBox.dart';

class ChatWithAdminSupport extends StatefulWidget {
  const ChatWithAdminSupport({Key? key}) : super(key: key);

  @override
  State<ChatWithAdminSupport> createState() => _ChatWithAdminSupportState();
}

class _ChatWithAdminSupportState extends State<ChatWithAdminSupport> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  FocusScopeNode _currentFocus = FocusScopeNode();
  FocusNode focusNode = FocusNode();

  bool _isRecording = false;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  String? _localRecordingPath;

  static const String serverUrl = 'https://support-server.108.jobs/app';
  static const String socketUrl = 'https://support-server.108.jobs';

  IO.Socket? _socket;
  String? _convId;
  String _myId = '';
  String _employeeToken = '';

  bool _isLoading = true;
  // bool _isInitialLoad = true;
  bool _isStarting = false;
  bool _sending = false;
  bool _isUploading = false;
  bool _socketConnected = false;
  bool _loadingMore = false;
  bool _hasMore = false;

  // Case info
  bool _isResolved = false;
  String _resolveNote = '';
  int? _caseNumber;
  String _resolvedBy = '';

  // Typing indicator
  final Set<String> _typingUsers = {};
  Timer? _typingTimer;
  bool _isEmittingTyping = false;

  // List of messages
  List<Map<String, dynamic>> _messages = [];

  // Attachments picking
  List<Map<String, dynamic>> _pendingAttachments = [];
  final Map<String, Size> _imageDimensions = {};

  @override
  void initState() {
    super.initState();
    _initChat();
    _scrollController.addListener(_onScroll);
    focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _recordingTimer?.cancel();
    _scrollController.dispose();
    _inputController.dispose();
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    _teardownSocket();
    super.dispose();
  }

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      // When user clicks/taps input box to start typing, wait a short moment for keyboard animation and viewport resizing to complete, then scroll to bottom
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && focusNode.hasFocus) {
          _scrollToBottom(animate: true);
        }
      });
    }
  }

  void _resolveSingleImageDimension(String url) {
    if (_imageDimensions.containsKey(url)) return;
    try {
      final imageProvider = NetworkImage(url);
      final ImageStream stream =
          imageProvider.resolve(createLocalImageConfiguration(context));
      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          if (mounted) {
            setState(() {
              _imageDimensions[url] = Size(
                info.image.width.toDouble(),
                info.image.height.toDouble(),
              );
            });
          }
          stream.removeListener(listener);
        },
        onError: (exception, stackTrace) {
          stream.removeListener(listener);
        },
      );
      stream.addListener(listener);
    } catch (e) {
      debugPrint("Failed to resolve single image dimension: $e");
    }
  }

  Future<void> _precacheInitialImages(
      List<Map<String, dynamic>> messages) async {
    if (!mounted) return;

    final imageMessages = messages
        .where((m) =>
            m['type'] == 'image' &&
            m['mediaUrl'] != null &&
            (m['mediaUrl'] as String).isNotEmpty)
        .toList();

    if (imageMessages.isEmpty) return;

    final List<Future<void>> cacheFutures = [];
    for (var msg in imageMessages) {
      final String? url = msg['mediaUrl'];
      if (url != null && url.isNotEmpty) {
        final completer = Completer<void>();
        final imageProvider = NetworkImage(url);
        final ImageStream stream =
            imageProvider.resolve(createLocalImageConfiguration(context));
        late ImageStreamListener listener;
        listener = ImageStreamListener(
          (ImageInfo info, bool synchronousCall) {
            if (mounted) {
              _imageDimensions[url] = Size(
                info.image.width.toDouble(),
                info.image.height.toDouble(),
              );
            }
            if (!completer.isCompleted) {
              completer.complete();
            }
            stream.removeListener(listener);
          },
          onError: (exception, stackTrace) {
            debugPrint(
                "Failed to resolve image size during precache for $url: $exception");
            if (!completer.isCompleted) {
              completer.complete();
            }
            stream.removeListener(listener);
          },
        );
        stream.addListener(listener);

        // Run standard precacheImage to populate flutter's ImageCache as well
        precacheImage(imageProvider, context).catchError((e) {
          debugPrint("Failed precacheImage for $url, error: $e");
        });

        cacheFutures.add(completer.future);
      }
    }

    if (cacheFutures.isNotEmpty) {
      try {
        // Freeze the loading shimmer until all initial image messages are fully loaded and size-calculated (up to 10 seconds timeout)
        await Future.wait(cacheFutures).timeout(const Duration(seconds: 10));
      } catch (e) {
        debugPrint("Precache initial images timeout or error: $e");
      }
    }
  }

  Future<void> _initChat() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Fetch token and profile ID
      final token = await SharedPrefsHelper.getString("employeeToken");
      _employeeToken = token ?? '';

      final profileProvider = context.read<ProfileProvider>();
      if (profileProvider.seekerProfile == null) {
        await profileProvider.fetchProfileSeeker();
      }
      _myId = profileProvider.seekerProfile?['_id'] ?? '';

      // 2. Fetch my ID explicitly from /users/me as fallback or confirmation
      try {
        final meRes = await fetchData(serverUrl + "/users/me");
        if (meRes != null && meRes is Map && meRes['data'] != null) {
          _myId = meRes['data']['_id'] ?? _myId;
        }
      } catch (e) {
        debugPrint("fetch /users/me failed: $e");
      }

      // 3. Connect socket
      _connectSocket();

      // 4. Fetch latest case
      await _fetchLatestCase();

      // 5. Pre-cache all initial images in loaded messages before turning off shimmer loading
      await _precacheInitialImages(_messages);
    } catch (e) {
      debugPrint("Init chat failed: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom(animate: false);
    }
  }

  void _connectSocket() {
    if (_employeeToken.isEmpty) return;
    _teardownSocket();

    debugPrint("Connecting socket to: $socketUrl");

    _socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .setAuth({'token': _employeeToken})
            .enableForceNew()
            .enableReconnection()
            .setReconnectionAttempts(8)
            .build());

    _socket!.onConnect((_) {
      debugPrint("Socket support connected!");
      setState(() {
        _socketConnected = true;
      });
      if (_convId != null) {
        _joinConv(_convId!);
        _markRead();
      }
    });

    _socket!.onDisconnect((_) {
      debugPrint("Socket support disconnected!");
      setState(() {
        _socketConnected = false;
        _typingUsers.clear();
      });
    });

    _socket!.onConnectError((err) {
      debugPrint("Socket connection error: $err");
      setState(() {
        _socketConnected = false;
      });
    });

    _socket!.on('new_message', (data) {
      debugPrint("Socket incoming message: $data");
      if (data == null || data is! Map) return;
      final msg = Map<String, dynamic>.from(data);
      final String incomingConvId = msg['conversationId'] ?? '';

      if (incomingConvId != _convId) return;

      final mapped = _rawToMsg(msg);
      _upsertMessage(mapped);

      if (!mapped['isMe']) {
        _markRead();
        // _playSound();
      }

      _scrollToBottom();
    });

    _socket!.on('new_conversation', (data) {
      if (data == null || data is! Map) return;
      final String newCid = data['_id'] ?? '';
      if (newCid.isNotEmpty) {
        setState(() {
          _convId = newCid;
        });
        _joinConv(newCid);
      }
    });

    _socket!.on('messages_read', (data) {
      if (data == null || data is! Map) return;
      final String cid = data['conversationId'] ?? '';
      final String userId = data['userId'] ?? '';
      if (cid != _convId) return;

      setState(() {
        for (var m in _messages) {
          if (userId == _myId) {
            if (!m['isMe']) m['isRead'] = true;
          } else {
            if (m['isMe']) m['isRead'] = true;
          }
        }
      });
    });

    _socket!.on('typing', (data) {
      if (data == null || data is! Map) return;
      final String cid = data['convId'] ?? '';
      final String userId = data['userId'] ?? '';
      final bool isTyping = data['isTyping'] ?? false;

      if (cid != _convId || userId == _myId) return;

      setState(() {
        if (isTyping) {
          _typingUsers.add(userId);
        } else {
          _typingUsers.remove(userId);
        }
      });
      _scrollToBottom();
    });

    _socket!.on('conversation_updated', (data) {
      if (data == null || data is! Map) return;
      final String cid = data['_id'] ?? '';
      if (cid != _convId) return;

      setState(() {
        _applyConvMeta(data);
      });
      _scrollToBottom();
    });
  }

  void _teardownSocket() {
    _stopTyping();
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket = null;
    _socketConnected = false;
    _typingUsers.clear();
  }

  void _joinConv(String id) {
    _socket?.emit('join_conversation', id);
  }

  void _applyConvMeta(Map<dynamic, dynamic> c) {
    _isResolved = c['isResolved'] ?? false;
    _resolveNote = c['resolveNote'] ?? '';
    _caseNumber = c['caseNumber'];

    final assigned = c['assignedAdminId'];
    if (assigned != null && assigned is Map) {
      _resolvedBy = assigned['externalId'] ?? '';
    } else {
      _resolvedBy = '';
    }
  }

  Future<bool> _fetchLatestCase() async {
    try {
      // 1. Try to fetch the latest conversation from /conversations list
      final convsRes = await fetchData(serverUrl + "/conversations");
      if (convsRes != null && convsRes is Map && convsRes['data'] != null) {
        final List convs = convsRes['data'];
        if (convs.isNotEmpty) {
          final latestConv = convs.first;
          setState(() {
            _convId = latestConv['_id'];
            _applyConvMeta(latestConv);
          });
          if (_convId != null) {
            _joinConv(_convId!);
            await _loadMessages();
            await _markRead();
          }
          return true;
        }
      }

      // 2. Fallback to /support if conversations list is empty
      final res = await fetchData(serverUrl + "/support");
      if (res != null && res is Map && res['data'] != null) {
        final data = res['data'];
        setState(() {
          _convId = data['_id'];
          _applyConvMeta(data);
        });
        if (_convId != null) {
          _joinConv(_convId!);
          await _loadMessages();
          await _markRead();
        }
        return true;
      }
    } catch (e) {
      debugPrint("Fetch latest case failed: $e");
    }
    return false;
  }

  Future<void> _createNewCase() async {
    setState(() {
      _isStarting = true;
    });

    try {
      final res = await postData(serverUrl + "/support", {});
      if (res != null && res is Map && res['data'] != null) {
        final data = res['data'];
        setState(() {
          _convId = data['_id'];
          _applyConvMeta(data);
        });
        if (_convId != null) {
          _joinConv(_convId!);
          await _loadMessages();
          await _markRead();
        }
      }
    } catch (e) {
      Get.snackbar("Error".tr, "Could not create support channel".tr);
    } finally {
      setState(() {
        _isStarting = false;
      });
      _scrollToBottom(animate: false);
    }
  }

  Future<void> _loadMessages() async {
    if (_convId == null) return;
    try {
      final res = await fetchData(
          serverUrl + "/conversations/$_convId/messages?limit=30");
      if (res != null && res is Map && res['data'] != null) {
        final List raw = res['data'];
        final List<Map<String, dynamic>> mapped =
            raw.map((m) => _rawToMsg(m)).toList();
        setState(() {
          _messages = mapped;
          _hasMore = res['hasMore'] ?? false;
        });
        _scrollToBottom(animate: false);
      }
    } catch (e) {
      debugPrint("Load messages error: $e");
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_loadingMore || !_hasMore || _convId == null || _messages.isEmpty)
      return;
    setState(() {
      _loadingMore = true;
    });

    final oldest = _messages.first;
    final String before = oldest['timestamp'] ?? '';

    try {
      final res = await fetchData(serverUrl +
          "/conversations/$_convId/messages?limit=30&before=${Uri.encodeComponent(before)}");
      if (res != null && res is Map && res['data'] != null) {
        final List raw = res['data'];
        final List<Map<String, dynamic>> mapped =
            raw.map((m) => _rawToMsg(m)).toList();
        setState(() {
          _messages.insertAll(0, mapped);
          _hasMore = res['hasMore'] ?? false;
        });
      }
    } catch (e) {
      debugPrint("Load more messages failed: $e");
    } finally {
      setState(() {
        _loadingMore = false;
      });
    }
  }

  Future<void> _markRead() async {
    if (_convId == null) return;
    try {
      await http.patch(
        Uri.parse(serverUrl + "/conversations/$_convId/read"),
        headers: {
          "content-type": "application/json",
          "authorization": _employeeToken,
        },
      );
      setState(() {
        for (var m in _messages) {
          if (!m['isMe']) m['isRead'] = true;
        }
      });
    } catch (e) {
      debugPrint("Mark read error: $e");
    }
  }

  Map<String, dynamic> _rawToMsg(Map<dynamic, dynamic> m) {
    final List readBy = m['readBy'] is List ? m['readBy'] : [];
    final List<String> readByIds = readBy
        .map((r) {
          if (r == null) return '';
          if (r is String) return r;
          if (r is Map && r.containsKey('_id'))
            return String.fromCharCodes(r['_id']);
          return r.toString();
        })
        .where((element) => element.isNotEmpty)
        .toList();

    final String senderId =
        m['sender'] is Map ? (m['sender']['_id'] ?? '') : (m['sender'] ?? '');
    final bool isMe = senderId == _myId;
    final String type = m['type'] ?? 'text';
    final String mediaUrl = m['mediaUrl'] ?? '';
    final String content = m['content'] ?? '';

    return {
      'id': m['_id']?.toString() ?? '',
      'text': content.trim(),
      'type': type,
      'mediaUrl': mediaUrl.trim(),
      'sizeBytes': m['mediaSize'] is num ? m['mediaSize'] as int : null,
      'isMe': isMe,
      'isRead':
          isMe ? readByIds.any((id) => id != _myId) : readByIds.contains(_myId),
      'timestamp': m['createdAt'] ?? '',
    };
  }

  void _upsertMessage(Map<String, dynamic> msg) {
    if (msg['type'] == 'image' &&
        msg['mediaUrl'] != null &&
        (msg['mediaUrl'] as String).isNotEmpty) {
      _resolveSingleImageDimension(msg['mediaUrl']);
    }

    setState(() {
      final i = _messages.indexWhere((m) => m['id'] == msg['id']);
      if (i >= 0) {
        if (_messages[i]['isRead'] && !msg['isRead']) {
          _messages[i] = {...msg, 'isRead': true};
        } else {
          _messages[i] = msg;
        }
      } else {
        _messages.add(msg);
      }
    });
  }

  void _scrollToBottom({bool animate = true, int retryCount = 0}) {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;

        if (maxScroll > 0) {
          if (animate) {
            _scrollController.animateTo(
              maxScroll,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          } else {
            _scrollController.jumpTo(maxScroll);
          }
        }

        // Keep stabilizing scroll position during initial rendering phase (e.g. while layout settles)
        if (retryCount < 6) {
          Future.delayed(const Duration(milliseconds: 100), () {
            _scrollToBottom(animate: animate, retryCount: retryCount + 1);
          });
        }
      } else if (retryCount < 10) {
        // Controller not attached yet, wait and retry
        Future.delayed(const Duration(milliseconds: 50), () {
          _scrollToBottom(animate: animate, retryCount: retryCount + 1);
        });
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels < 80) {
      _loadMoreMessages();
    }
  }

  // Pick attachments
  Future<void> _pickAttachment(String type) async {
    try {
      if (type == 'camera') {
        final XFile? file = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (file != null) {
          final size = await file.length();
          setState(() {
            _pendingAttachments.add({
              'type': 'image',
              'name': file.name,
              'path': file.path,
              'size': size,
            });
          });
        }
      } else if (type == 'gallery') {
        final List<XFile> files = await _imagePicker.pickMultiImage(
          imageQuality: 85,
        );
        if (files.isNotEmpty) {
          for (var file in files) {
            final size = await file.length();
            setState(() {
              _pendingAttachments.add({
                'type': 'image',
                'name': file.name,
                'path': file.path,
                'size': size,
              });
            });
          }
        }
      } else if (type == 'video') {
        final XFile? file = await _imagePicker.pickVideo(
          source: ImageSource.gallery,
        );
        if (file != null) {
          final size = await file.length();
          setState(() {
            _pendingAttachments.add({
              'type': 'video',
              'name': file.name,
              'path': file.path,
              'size': size,
            });
          });
        }
      } else if (type == 'doc') {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            'pdf',
            'doc',
            'docx',
            'xls',
            'xlsx',
            'txt',
            'png',
            'jpg'
          ],
        );
        if (result != null && result.files.single.path != null) {
          final file = result.files.single;
          setState(() {
            String mimeType = 'file';
            if (file.extension == 'png' ||
                file.extension == 'jpg' ||
                file.extension == 'jpeg') {
              mimeType = 'image';
            } else if (file.extension == 'mp4' || file.extension == 'mov') {
              mimeType = 'video';
            }

            _pendingAttachments.add({
              'type': mimeType,
              'name': file.name,
              'path': file.path!,
              'size': file.size,
            });
          });
        }
      }
    } catch (e) {
      debugPrint("Pick attachment error: $e");
    }
  }

  void _removePending(int index) {
    setState(() {
      _pendingAttachments.removeAt(index);
    });
  }

  MediaType _getMimeType(String filePath, String localType) {
    final extension = filePath.split('.').last.toLowerCase();

    if (localType == 'image') {
      if (extension == 'png') return MediaType('image', 'png');
      if (extension == 'gif') return MediaType('image', 'gif');
      if (extension == 'webp') return MediaType('image', 'webp');
      return MediaType('image', 'jpeg');
    } else if (localType == 'video') {
      if (extension == 'mov') return MediaType('video', 'quicktime');
      if (extension == '3gp') return MediaType('video', '3gpp');
      return MediaType('video', 'mp4');
    } else if (localType == 'audio') {
      if (extension == 'mp3') return MediaType('audio', 'mpeg');
      if (extension == 'wav') return MediaType('audio', 'wav');
      if (extension == 'ogg') return MediaType('audio', 'ogg');
      if (extension == 'm4a') return MediaType('audio', 'mp4');
      return MediaType('audio', 'aac');
    }

    // Fallback for doc/file types
    if (extension == 'pdf') return MediaType('application', 'pdf');
    if (extension == 'doc' || extension == 'docx')
      return MediaType('application', 'msword');
    if (extension == 'xls' || extension == 'xlsx')
      return MediaType('application', 'vnd.ms-excel');
    if (extension == 'txt') return MediaType('text', 'plain');

    return MediaType('application', 'octet-stream');
  }

  Future<dynamic> _uploadChatFile(String filePath, String localType) async {
    final employeeToken = _employeeToken;
    final fileName = filePath.split('/').last;
    final mimeType = _getMimeType(filePath, localType);

    final formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: mimeType,
      ),
    });

    try {
      final res = await dio.Dio().post(
        serverUrl + "/upload",
        data: formData,
        options: dio.Options(headers: {
          "authorization": employeeToken,
        }),
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      debugPrint("Upload chat file error: $e");
    }
    return null;
  }

  // Upload attachments and send
  Future<void> _handleSend() async {
    final text = _inputController.text.trim();
    if (text.isEmpty && _pendingAttachments.isEmpty) return;

    if (_convId == null) {
      await _createNewCase();
    }
    if (_convId == null) return;

    _stopTyping();
    setState(() {
      _sending = true;
    });

    try {
      // 1. Upload any pending attachments
      if (_pendingAttachments.isNotEmpty) {
        setState(() {
          _isUploading = true;
        });

        for (var att in _pendingAttachments) {
          final String path = att['path'];
          final String name = att['name'];
          final String type = att['type'];

          debugPrint("Uploading attachment: $name");
          final uploadRes = await _uploadChatFile(path, type);

          if (uploadRes != null && uploadRes is Map) {
            final String mediaUrl = uploadRes['url'] ?? '';
            final int mediaSize = uploadRes['size'] ?? att['size'];
            String serverType = uploadRes['type'] ?? type;
            if (serverType == 'file') {
              if (type == 'image' || type == 'video' || type == 'audio') {
                serverType = type;
              }
            }

            await _postMessage({
              'content': serverType == 'image' ? '' : name,
              'type': serverType,
              'mediaUrl': mediaUrl,
              'mediaSize': mediaSize,
            });
          }
        }

        setState(() {
          _pendingAttachments.clear();
          _isUploading = false;
        });
      }

      // 2. Send text message
      if (text.isNotEmpty) {
        _inputController.clear();
        await _postMessage({
          'content': text,
          'type': 'text',
        });
      }
    } catch (e) {
      debugPrint("Send message failed: $e");
      Get.snackbar("Error".tr, "Failed to send message".tr);
    } finally {
      setState(() {
        _sending = false;
        _isUploading = false;
      });
      _scrollToBottom();
    }
  }

  Future<void> _postMessage(Map<String, dynamic> payload) async {
    if (_convId == null) return;
    try {
      final res =
          await postData(serverUrl + "/conversations/$_convId/messages", {
        'content': payload['content'] ?? '',
        'type': payload['type'] ?? 'text',
        'mediaUrl': payload['mediaUrl'],
        'mediaSize': payload['mediaSize'],
      });

      if (res != null && res is Map && res['data'] != null) {
        final data = res['data'];
        final conversation = res['conversation'];

        if (conversation != null && conversation is Map) {
          final String cid = conversation['_id'] ?? '';
          if (cid.isNotEmpty && cid != _convId) {
            setState(() {
              _convId = cid;
              _isResolved = false;
              _resolveNote = '';
              _caseNumber = conversation['caseNumber'];
              _resolvedBy = '';
            });
            _joinConv(cid);
          }
        }

        _upsertMessage(_rawToMsg(data));
      }
    } catch (e) {
      debugPrint("Post message failed: $e");
    }
  }

  void _onTextInput(String text) {
    if (_convId == null) return;
    if (!_isEmittingTyping) {
      _isEmittingTyping = true;
      _socket?.emit('typing', {'convId': _convId, 'isTyping': true});
    }
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), _stopTyping);
  }

  void _stopTyping() {
    if (!_isEmittingTyping || _convId == null) return;
    _isEmittingTyping = false;
    _socket?.emit('typing', {'convId': _convId, 'isTyping': false});
    _typingTimer?.cancel();
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.setAsset('assets/audio/kuru1.mp3');
      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Play sound error: $e");
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final Directory tempDir = await getTemporaryDirectory();
        final String path =
            '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        _localRecordingPath = path;

        await _audioRecorder
            .start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);

        setState(() {
          _isRecording = true;
          _recordingSeconds = 0;
        });

        _recordingTimer?.cancel();
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingSeconds++;
          });
        });
      } else {
        Get.snackbar("Permission Denied".tr,
            "Microphone permission is required to record audio.".tr);
      }
    } catch (e) {
      debugPrint("Start recording failed: $e");
    }
  }

  Future<void> _stopRecording({required bool andSend}) async {
    _recordingTimer?.cancel();
    _recordingTimer = null;

    try {
      final String? path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null && andSend) {
        final file = File(path);
        final size = await file.length();
        setState(() {
          _pendingAttachments.add({
            'type': 'audio',
            'name': 'VoiceMessage.m4a',
            'path': path,
            'size': size,
          });
        });

        _handleSend();
      }
    } catch (e) {
      debugPrint("Stop recording failed: $e");
    }
  }

  void _cancelRecording() async {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    try {
      await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
      if (_localRecordingPath != null) {
        final file = File(_localRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint("Cancel recording failed: $e");
    }
  }

  String _formatTime(String ts) {
    if (ts.isEmpty) return '';
    try {
      final dt = DateTime.parse(ts).toLocal();
      // return DateFormat('hh:mm a').format(dt);
      return DateFormat('HH:mm').format(dt);
    } catch (e) {
      return '';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    //final profileProvider = context.watch<ProfileProvider>();
    // final String title = profileProvider.firstName.isNotEmpty
    //     ? "${profileProvider.firstName} ${profileProvider.lastName}"
    //     : "Support";
    final String title = "Admin Support";

    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: _buildAppBar(title),
        body: SafeArea(
          child: Column(
            children: [
              // Connection error bar
              if (!_socketConnected && !_isLoading) _buildErrorBar(),

              // Chat body
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.0, 0.05),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ));
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: _isLoading
                      ? const ChatShimmerLoading(key: ValueKey('loading'))
                      : _convId == null
                          ? _buildWelcomeScreen()
                          : _buildMessagesList(),
                ),
              ),

              // Cases resolution banner
              if (_isResolved) _buildResolvedBanner(),

              // Pending attachments row
              if (_pendingAttachments.isNotEmpty) _buildPendingAttachmentsRow(),

              // Input Composer
              _buildComposer(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String title) {
    return AppBar(
      backgroundColor: AppColors.primaryCustom,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.white.withOpacity(0.2),
            child: Text(
              title.isNotEmpty ? title[0].toUpperCase() : 'S',
              style: bodyTextMaxNormal(null, AppColors.white, FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style:
                      bodyTextMaxNormal(null, AppColors.white, FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                // Text(
                //   !_socketConnected
                //       ? "Connecting...".tr
                //       : _isResolved
                //           ? "Resolved".tr
                //           : "Online".tr,
                //   style: TextStyle(
                //       color: Colors.white.withOpacity(0.7), fontSize: 11),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBar() {
    return Container(
      width: double.infinity,
      color: AppColors.danger100,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: AppColors.iconDanger, size: 16),
          SizedBox(width: 8),
          Text(
            "Waiting for network".tr,
            style: bodyTextSmall(null, AppColors.danger, null),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      key: const ValueKey('welcome'),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryCustom.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chat_bubble_outline,
                  size: 64, color: AppColors.primaryCustom),
            ),
            const SizedBox(height: 24),
            Text(
              "Hello",
              style: bodyTextMaxNormal(null, AppColors.dark, FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Message Support \n Text, Photos, Videos, Files or Voice.".tr,
              textAlign: TextAlign.center,
              style: bodyTextMinNormal(null, AppColors.dark, null),
            ),
            const SizedBox(height: 32),
            // ElevatedButton(
            //   onPressed: _isStarting ? null : _createNewCase,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColors.primaryCustom,
            //     foregroundColor: Colors.white,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12)),
            //     elevation: 2,
            //   ),
            //   child: _isStarting
            //       ? const SizedBox(
            //           width: 20,
            //           height: 20,
            //           child: CircularProgressIndicator(
            //               color: Colors.white, strokeWidth: 2))
            //       : Text("Start Chat".tr,
            //           style: const TextStyle(
            //               fontSize: 15, fontWeight: FontWeight.bold)),
            // ),
          ],
        ),
      ),
    );
  }

  bool _isToday(String ts) {
    if (ts.isEmpty) return true;
    try {
      final dt = DateTime.parse(ts).toLocal();
      final now = DateTime.now();
      return dt.year == now.year && dt.month == now.month && dt.day == now.day;
    } catch (e) {
      return true;
    }
  }

  String _formatDateSeparator(String ts) {
    if (ts.isEmpty) return '';
    try {
      final dt = DateTime.parse(ts).toLocal();
      final formatted = DateFormat('EEE d MMM yyyy , HH:mm').format(dt);
      if (_isToday(ts)) {
        return "Today, $formatted";
      }
      return formatted;
    } catch (e) {
      return '';
    }
  }

  bool _shouldShowDateSeparator(int index) {
    if (index < 0 || index >= _messages.length) return false;
    final m = _messages[index];
    final String ts = m['timestamp'] ?? '';
    if (ts.isEmpty) return false;

    if (index == 0) {
      return true;
    }

    final prev = _messages[index - 1];
    final String prevTs = prev['timestamp'] ?? '';
    if (prevTs.isEmpty) return true;

    try {
      final dt = DateTime.parse(ts).toLocal();
      final prevDt = DateTime.parse(prevTs).toLocal();
      return dt.year != prevDt.year ||
          dt.month != prevDt.month ||
          dt.day != prevDt.day;
    } catch (e) {
      return true;
    }
  }

  Widget _buildDateSeparatorWidget(String dateText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.dark,
              thickness: 0.1,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.dark100,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              dateText,
              style: bodyTextSmall(null, AppColors.fontDark, null),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.dark,
              thickness: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (_messages.isEmpty) {
      return Center(
        key: const ValueKey('empty_messages'),
        child: Text(
          "No messages yet.".tr,
          style: bodyTextMaxSmall(null, AppColors.dark, null),
        ),
      );
    }

    return GestureDetector(
      key: const ValueKey('messages_list'),
      onTap: () {
        focusNode.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _messages.length + (_typingUsers.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _messages.length) {
            return _buildTypingRow();
          }

          final m = _messages[index];
          final bool showDateSeparator = _shouldShowDateSeparator(index);
          final Widget messageRow =
              KeepAliveWrapper(child: _buildMessageRow(m));

          if (showDateSeparator) {
            final String dateText = _formatDateSeparator(m['timestamp']);
            if (dateText.isNotEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDateSeparatorWidget(dateText),
                  messageRow,
                ],
              );
            }
          }

          return messageRow;
        },
      ),
    );
  }

  Widget _buildBubbleDownloadButton(String type, String url) {
    return GestureDetector(
      onTap: () {
        if (type == 'image') {
          _saveLocalImage(url);
        } else if (type == 'video') {
          _saveLocalVideo(url);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.dark100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.download,
          color: AppColors.iconDark,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMessageRow(Map<String, dynamic> m) {
    final bool isMe = m['isMe'] ?? false;
    final String type = m['type'] ?? 'text';
    final String text = m['text'] ?? '';
    final String mediaUrl = m['mediaUrl'] ?? '';
    final int? sizeBytes = m['sizeBytes'];
    final bool isRead = m['isRead'] ?? false;
    final String timeStr = _formatTime(m['timestamp']);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // If isMe (sent by us), show download button on the LEFT of the bubble
            if (isMe &&
                mediaUrl.isNotEmpty &&
                (type == 'image' || type == 'video')) ...[
              _buildBubbleDownloadButton(type, mediaUrl),
              const SizedBox(width: 8),
            ],

            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Media card attachment
                  if (mediaUrl.isNotEmpty && type != 'text') ...[
                    _buildMediaCard(type, mediaUrl, text, sizeBytes),
                    SizedBox(height: 5),
                  ],

                  // Text message bubble
                  if (text.isNotEmpty && (type == 'text' || mediaUrl.isEmpty))
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            isMe ? AppColors.primaryCustom : AppColors.dark100,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 16),
                        ),
                        border: isMe
                            ? null
                            : Border.all(
                                color: AppColors.black.withOpacity(0.05),
                                width: 0.5),
                      ),
                      child: _buildTextWithLinks(text, isMe),
                    ),

                  // Metadata row (Time and ticks)
                  Padding(
                    padding: const EdgeInsets.only(top: 3, left: 4, right: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          timeStr,
                          style:
                              bodyTextCustom(null, null, AppColors.dark, null),
                        ),
                        SizedBox(width: 5),
                        if (isMe) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              isRead ? "✓✓" : "✓",
                              style: bodyTextSmall(
                                  null,
                                  isRead
                                      ? AppColors.primaryCustom
                                      : AppColors.dark400,
                                  FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // If !isMe (sent by admin), show download button on the RIGHT of the bubble
            if (!isMe &&
                mediaUrl.isNotEmpty &&
                (type == 'image' || type == 'video')) ...[
              const SizedBox(width: 8),
              _buildBubbleDownloadButton(type, mediaUrl),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextWithLinks(String text, bool isMe) {
    final RegExp urlRegExp = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    final Iterable<RegExpMatch> matches = urlRegExp.allMatches(text);

    if (matches.isEmpty) {
      return Text(
        text,
        style: bodyTextMinNormal(
          null,
          isMe ? AppColors.white : AppColors.dark,
          FontWeight.bold,
        ),
      );
    }

    final List<String> urls = [];
    String plainText = text;

    for (final RegExpMatch match in matches) {
      final String urlString = match.group(0)!;
      urls.add(urlString);
      plainText = plainText.replaceAll(urlString, '');
    }

    plainText = plainText.trim();
    if (plainText.endsWith(':')) {
      plainText = plainText.substring(0, plainText.length - 1).trim();
    }

    final List<Widget> children = [];

    // 1. Links on top
    for (int i = 0; i < urls.length; i++) {
      final String urlString = urls[i];
      children.add(
        GestureDetector(
          onTap: () => _launchURL(urlString),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: isMe ? AppColors.primary600 : AppColors.dark200,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              urlString,
              style: bodyTextMinNormal(
                  null,
                  isMe ? Colors.white : AppColors.primaryCustom,
                  FontWeight.bold),
            ),
          ),
        ),
      );
      if (i < urls.length - 1) {
        children.add(const SizedBox(height: 4));
      }
    }

    // 2. Text under link
    if (plainText.isNotEmpty) {
      children.add(const SizedBox(height: 8));
      children.add(
        Text(
          plainText,
          style: bodyTextMinNormal(
            null,
            isMe ? AppColors.white : AppColors.dark,
            FontWeight.bold,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildMediaCard(String type, String url, String name, int? sizeBytes) {
    if (type == 'image') {
      final Size? cachedSize = _imageDimensions[url];

      Widget imageWidget = Image.network(
        url,
        fit: BoxFit.contain,
        gaplessPlayback: true,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            width: cachedSize == null ? 200 : null,
            height: cachedSize == null ? 150 : null,
            color: Colors.black.withOpacity(0.04),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: 200,
          height: 150,
          color: Colors.grey[200],
          child:
              const Icon(Icons.broken_image, size: 40, color: Colors.black26),
        ),
      );

      // If dimensions are cached/resolved, wrap in AspectRatio to prevent layout shifts!
      if (cachedSize != null && cachedSize.width > 0 && cachedSize.height > 0) {
        imageWidget = AspectRatio(
          aspectRatio: cachedSize.width / cachedSize.height,
          child: imageWidget,
        );
      }

      return GestureDetector(
        onTap: () {
          focusNode.unfocus();
          _openLightbox(url, name);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.black.withOpacity(0.04),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: imageWidget,
            ),
          ),
        ),
      );
    }

    if (type == 'video') {
      return InlineVideoPlayer(
        url: url,
        onDownload: () => _saveLocalVideo(url),
      );
    }

    if (type == 'audio') {
      return InlineAudioPlayer(url: url);
    }

    // Parse the file extension to dynamically theme the layout
    final String extension =
        name.contains('.') ? name.split('.').last.toUpperCase() : 'FILE';

    Color indicatorBgColor;
    Color indicatorColor;
    IconData fileIcon = Icons.description;

    if (extension == 'PDF') {
      indicatorBgColor = const Color(0xFFFEF2F2); // soft red
      indicatorColor = const Color(0xFFEF4444); // red
      fileIcon = Icons.picture_as_pdf;
    } else if (extension == 'DOC' || extension == 'DOCX') {
      indicatorBgColor = const Color(0xFFEFF6FF); // soft blue
      indicatorColor = const Color(0xFF3B82F6); // blue
      fileIcon = Icons.article;
    } else if (extension == 'XLS' || extension == 'XLSX') {
      indicatorBgColor = const Color(0xFFECFDF5); // soft green
      indicatorColor = const Color(0xFF10B981); // green
      fileIcon = Icons.table_chart;
    } else if (extension == 'ZIP' || extension == 'RAR') {
      indicatorBgColor = const Color(0xFFFFF7ED); // soft orange
      indicatorColor = const Color(0xFFF97316); // orange
      fileIcon = Icons.folder_zip;
    } else {
      indicatorBgColor = const Color(0xFFF9FAFB); // soft grey
      indicatorColor = const Color(0xFF6B7280); // grey
      fileIcon = Icons.insert_drive_file;
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 1)),
        ],
      ),
      child: InkWell(
        onTap: () => _launchURL(url),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: indicatorBgColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(fileIcon, color: indicatorColor, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: indicatorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          extension,
                          style: bodyTextCustom(
                              8, null, indicatorColor, FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Text(
                    name.isNotEmpty ? name : "Attachment".tr,
                    style: bodyTextSmall(null, AppColors.dark, null),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (sizeBytes != null) ...[
                    SizedBox(height: 1),
                    Text(
                      _formatFileSize(sizeBytes),
                      style: bodyTextCustom(10, null, AppColors.dark500, null),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_downward, color: AppColors.iconDark, size: 16),
          ],
        ),
      ),
    );
  }

  void _openLightbox(String url, String name) {
    // 1. Gather all successfully uploaded image messages in chronological order
    final imageMessages = _messages
        .where((m) =>
            m['type'] == 'image' &&
            m['mediaUrl'] != null &&
            (m['mediaUrl'] as String).isNotEmpty)
        .toList();

    // 2. Locate the index of the tapped image
    int initialIndex = imageMessages.indexWhere((m) => m['mediaUrl'] == url);
    if (initialIndex == -1) {
      // Fallback in case the specific URL is not yet in the message list
      imageMessages.insert(0, {
        'mediaUrl': url,
        'text': name,
        'type': 'image',
      });
      initialIndex = 0;
    }

    // 3. Navigate to the swipeable multi-image lightbox gallery
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageGalleryLightbox(
          imageMessages: imageMessages,
          initialIndex: initialIndex,
          onSave: _saveLocalImage,
        ),
      ),
    );
  }

  Future<void> _saveLocalImage(String url) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );

      final response = await http.get(Uri.parse(url));
      if (!mounted) return;

      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        bool permissionGranted = false;

        if (Platform.isIOS) {
          var statusPhotosIOS = await Permission.photos.status;
          if (statusPhotosIOS.isGranted) {
            permissionGranted = true;
          } else if (statusPhotosIOS.isDenied) {
            final requestStatus = await Permission.photos.request();
            if (!mounted) return;
            if (requestStatus.isGranted) {
              permissionGranted = true;
            }
          } else {
            Navigator.pop(context);
            if (!mounted) return;
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return NewVer5CustAlertDialogWarningBtnConfirm(
                  title: "warning".tr,
                  contentText: "want_access_photos".tr,
                  textButton: "ok".tr,
                  press: () async {
                    await openAppSettings();
                    Future.delayed(const Duration(seconds: 1), () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    });
                  },
                );
              },
            );
            return;
          }
        } else if (Platform.isAndroid) {
          var statusMediaLibraryAndroid = await Permission.mediaLibrary.status;
          if (statusMediaLibraryAndroid.isGranted) {
            permissionGranted = true;
          } else if (statusMediaLibraryAndroid.isDenied) {
            final requestStatus = await Permission.photos.request();
            if (!mounted) return;
            if (requestStatus.isGranted) {
              permissionGranted = true;
            }
          } else {
            Navigator.pop(context);
            if (!mounted) return;
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return NewVer5CustAlertDialogWarningBtnConfirm(
                  title: "warning".tr,
                  contentText: "want_access_photos".tr,
                  textButton: "ok".tr,
                  press: () async {
                    await openAppSettings();
                    Future.delayed(const Duration(seconds: 1), () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    });
                  },
                );
              },
            );
            return;
          }
        }

        if (permissionGranted) {
          Navigator.pop(context);
          final result = await ImageGallerySaverPlus.saveImage(bytes);
          if (!mounted) return;
          if (result != null && result['isSuccess'] == true) {
            await showDialog(
              context: context,
              builder: (context) {
                return CustAlertDialogSuccessWithoutBtn(
                  title: "successfully".tr,
                  contentText: "photo_saved".tr,
                );
              },
            );
          } else {
            await showDialog(
              context: context,
              builder: (context) {
                return CustAlertDialogWarningWithoutBtn(
                  title: "warning".tr,
                  contentText: "can_not_save_photo".tr,
                );
              },
            );
          }
        }
      } else {
        Navigator.pop(context);
        Get.snackbar("Error".tr, "Failed to download image".tr);
      }
    } catch (e) {
      debugPrint("Download image error: $e");
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      Get.snackbar("Error".tr, "Failed to save image".tr);
    }
  }

  Future<void> _saveLocalVideo(String url) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomLoadingLogoCircle();
        },
      );

      bool permissionGranted = false;

      if (Platform.isIOS) {
        var statusPhotosIOS = await Permission.photos.status;
        if (statusPhotosIOS.isGranted) {
          permissionGranted = true;
        } else if (statusPhotosIOS.isDenied) {
          final requestStatus = await Permission.photos.request();
          if (!mounted) return;
          if (requestStatus.isGranted) {
            permissionGranted = true;
          }
        } else {
          Navigator.pop(context);
          if (!mounted) return;
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return NewVer5CustAlertDialogWarningBtnConfirm(
                title: "warning".tr,
                contentText: "want_access_photos".tr,
                textButton: "ok".tr,
                press: () async {
                  await openAppSettings();
                  Future.delayed(const Duration(seconds: 1), () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  });
                },
              );
            },
          );
          return;
        }
      } else if (Platform.isAndroid) {
        var statusMediaLibraryAndroid = await Permission.mediaLibrary.status;
        if (statusMediaLibraryAndroid.isGranted) {
          permissionGranted = true;
        } else if (statusMediaLibraryAndroid.isDenied) {
          final requestStatus = await Permission.photos.request();
          if (!mounted) return;
          if (requestStatus.isGranted) {
            permissionGranted = true;
          }
        } else {
          Navigator.pop(context);
          if (!mounted) return;
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return NewVer5CustAlertDialogWarningBtnConfirm(
                title: "warning".tr,
                contentText: "want_access_photos".tr,
                textButton: "ok".tr,
                press: () async {
                  await openAppSettings();
                  Future.delayed(const Duration(seconds: 1), () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  });
                },
              );
            },
          );
          return;
        }
      }

      if (permissionGranted) {
        final tempDir = await getTemporaryDirectory();
        final fileName = url.split('/').last.split('?').first;
        final savePath = "${tempDir.path}/$fileName";

        final dio.Dio myDio = dio.Dio();
        await myDio.download(url, savePath);

        if (!mounted) return;

        final result = await ImageGallerySaverPlus.saveFile(savePath);
        if (!mounted) return;

        Navigator.pop(context);

        if (result != null && result['isSuccess'] == true) {
          await showDialog(
            context: context,
            builder: (context) {
              return CustAlertDialogSuccessWithoutBtn(
                title: "successfully".tr,
                contentText: Get.locale?.languageCode == 'la'
                    ? "ບັນທຶກວິດີໂອສຳເລັດ"
                    : "Video saved to this device",
              );
            },
          );
        } else {
          await showDialog(
            context: context,
            builder: (context) {
              return CustAlertDialogWarningWithoutBtn(
                title: "warning".tr,
                contentText: Get.locale?.languageCode == 'la'
                    ? "ບໍ່ສາມາດບັນທຶກວິດີໂອໄດ້"
                    : "Can't save this video",
              );
            },
          );
        }
      } else {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint("Download video error: $e");
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      Get.snackbar(
        "Error".tr,
        Get.locale?.languageCode == 'la'
            ? "ບໍ່ສາມາດບັນທຶກວິດີໂອໄດ້"
            : "Failed to save video",
      );
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error".tr, "Could not open attachment link".tr);
    }
  }

  Widget _buildTypingRow() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _BouncingDot(delay: 0),
            SizedBox(width: 4),
            _BouncingDot(delay: 150),
            SizedBox(width: 4),
            _BouncingDot(delay: 300),
          ],
        ),
      ),
    );
  }

  Widget _buildResolvedBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success100,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Resolved".tr,
                  style: bodyTextMaxSmall(
                      null, AppColors.success, FontWeight.bold),
                ),
                if (_resolveNote.isNotEmpty) ...[
                  SizedBox(height: 2),
                  Text(
                    _resolveNote,
                    style: bodyTextMiniSmall(null, AppColors.success, null),
                  ),
                ],
                SizedBox(height: 4),
                Text(
                  "Send a message below to start a new chat".tr,
                  style: bodyTextMiniSmall(null, AppColors.success, null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingAttachmentsRow() {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _pendingAttachments.length,
        itemBuilder: (context, index) {
          final att = _pendingAttachments[index];
          final String name = att['name'];
          final String type = att['type'];
          final String path = att['path'];

          Widget mediaWidget;

          if (type == 'image') {
            mediaWidget = Image.file(
              File(path),
              width: 76,
              height: 76,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 76,
                height: 76,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image,
                    size: 24, color: Colors.black38),
              ),
            );
          } else if (type == 'video') {
            mediaWidget = Container(
              width: 76,
              height: 76,
              color: AppColors.dark,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.play_circle_outline,
                      color: Colors.white, size: 28),
                  Positioned(
                    bottom: 4,
                    child: Text(
                      "VIDEO",
                      style: bodyTextCustom(
                          8, null, AppColors.dark, FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          } else if (type == 'audio') {
            mediaWidget = Container(
              width: 76,
              height: 76,
              color: AppColors.primaryCustom.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic, color: AppColors.primaryCustom, size: 24),
                  SizedBox(height: 4),
                  Text(
                    "AUDIO",
                    style: bodyTextCustom(
                        8, null, AppColors.dark, FontWeight.bold),
                  ),
                ],
              ),
            );
          } else {
            mediaWidget = Container(
              width: 76,
              height: 76,
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insert_drive_file, color: Colors.teal, size: 24),
                  SizedBox(height: 4),
                  Text(
                    "FILE",
                    style: bodyTextCustom(
                        8, null, AppColors.dark, FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 14, top: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black.withOpacity(0.08)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: mediaWidget,
                ),
              ),
              Positioned(
                right: 6,
                top: -2,
                child: GestureDetector(
                  onTap: () => _removePending(index),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_isRecording) ...[
            // Recording controls
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: _cancelRecording,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.fiber_manual_record,
                color: Colors.redAccent, size: 16),
            const SizedBox(width: 6),
            Text(
              "Recording ${_recordingSeconds ~/ 60}:${(_recordingSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                  fontSize: 13),
            ),
            const Spacer(),
            // Stop and Send button
            GestureDetector(
              onTap: () => _stopRecording(andSend: true),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: AppColors.primaryCustom, shape: BoxShape.circle),
                child: const Center(
                  child: Icon(Icons.send, color: Colors.white, size: 18),
                ),
              ),
            ),
          ] else ...[
            // Toolbar action buttons (Plus/Pick attachment menu)
            // Container(
            //   color: AppColors.red,
            //   child: IconButton(
            //     alignment: Alignment.center,
            //     icon: Icon(Icons.add_circle,
            //         color: AppColors.primaryCustom, size: 39),
            //     onPressed: () => _showAttachmentMenu(),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  focusNode.unfocus();
                  _showAttachmentMenu();
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: AppColors.primaryCustom, shape: BoxShape.circle),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),

            // TextInput Box
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: TextField(
                  focusNode: focusNode,
                  controller: _inputController,
                  maxLines: 4,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  onChanged: (text) {
                    _onTextInput(text);
                    setState(
                        () {}); // Redraw send/mic button based on empty status
                  },
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Type a message...".tr,
                    hintStyle:
                        const TextStyle(color: Colors.black38, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 6),

            // Send / Mic button
            GestureDetector(
              onTap: () {
                if (_sending || _isUploading) return;

                final text = _inputController.text.trim();
                if (text.isEmpty && _pendingAttachments.isEmpty) {
                  _startRecording();
                } else {
                  _handleSend();
                }
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: AppColors.primaryCustom, shape: BoxShape.circle),
                child: Center(
                  child: _sending || _isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Icon(
                          (_inputController.text.trim().isEmpty &&
                                  _pendingAttachments.isEmpty)
                              ? Icons.mic
                              : Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAttachmentMenu() {
    focusNode.unfocus();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Wrap(
              children: [
                ListTile(
                  leading:
                      Icon(Icons.photo_camera, color: AppColors.primary600),
                  title: Text("Take Photo".tr),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAttachment('camera');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo, color: AppColors.primary600),
                  title: Text("Photo Gallery".tr),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAttachment('gallery');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.videocam, color: AppColors.primary600),
                  title: Text("Choose Video".tr),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAttachment('video');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.mic, color: AppColors.primary600),
                  title: Text("Record Voice".tr),
                  onTap: () {
                    Navigator.pop(context);
                    _startRecording();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.insert_drive_file,
                      color: AppColors.primary600),
                  title: Text("Document / File".tr),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAttachment('doc');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

class ImageGalleryLightbox extends StatefulWidget {
  final List<Map<String, dynamic>> imageMessages;
  final int initialIndex;
  final Function(String) onSave;

  const ImageGalleryLightbox({
    Key? key,
    required this.imageMessages,
    required this.initialIndex,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ImageGalleryLightbox> createState() => _ImageGalleryLightboxState();
}

class _ImageGalleryLightboxState extends State<ImageGalleryLightbox> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMsg = widget.imageMessages[_currentIndex];
    final String currentUrl = currentMsg['mediaUrl'] ?? '';
    final String currentText = currentMsg['text'] ?? '';
    final String displayName =
        currentText.isNotEmpty ? currentText : "Image Preview";

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.iconDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          displayName,
          style: bodyTextNormal(null, AppColors.fontDark, null),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Container(
            // color: AppColors.red,
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.download, color: AppColors.iconDark),
              onPressed: () => widget.onSave(currentUrl),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: _isZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              itemCount: widget.imageMessages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _isZoomed = false; // Reset zoom state when page changes
                });
              },
              itemBuilder: (context, index) {
                final msg = widget.imageMessages[index];
                final String url = msg['mediaUrl'] ?? '';
                return ZoomableImage(
                  url: url,
                  onZoomChanged: (isZoomed) {
                    if (_isZoomed != isZoomed) {
                      setState(() {
                        _isZoomed = isZoomed;
                      });
                    }
                  },
                );
              },
            ),
          ),
          if (widget.imageMessages.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: Text(
                "${_currentIndex + 1} / ${widget.imageMessages.length}",
                style: TextStyle(
                    color: AppColors.dark500,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

class ZoomableImage extends StatefulWidget {
  final String url;
  final ValueChanged<bool> onZoomChanged;

  const ZoomableImage({
    Key? key,
    required this.url,
    required this.onZoomChanged,
  }) : super(key: key);

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        if (_animation != null) {
          _transformationController.value = _animation!.value;
        }
      });

    _transformationController.addListener(_handleTransformationChanged);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_handleTransformationChanged);
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleTransformationChanged() {
    final double scale = _transformationController.value.getMaxScaleOnAxis();
    widget.onZoomChanged(scale > 1.01);
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    final double scale = _transformationController.value.getMaxScaleOnAxis();
    final Matrix4 targetMatrix;

    if (scale > 1.01) {
      targetMatrix = Matrix4.identity();
      widget.onZoomChanged(false);
    } else {
      final localPosition = _doubleTapDetails?.localPosition ?? Offset.zero;
      final x = localPosition.dx;
      final y = localPosition.dy;

      targetMatrix = Matrix4.identity()
        ..translate(x, y)
        ..scale(2.5)
        ..translate(-x, -y);

      widget.onZoomChanged(true);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: targetMatrix,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        panEnabled: true,
        minScale: 1.0,
        maxScale: 4.0,

        // minScale: 0.5,
        // maxScale: 3.0,
        // panEnabled: true,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryCustom),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image,
                      size: 40, color: Colors.black26),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BouncingDot extends StatefulWidget {
  final int delay;
  const _BouncingDot({Key? key, required this.delay}) : super(key: key);

  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class InlineAudioPlayer extends StatefulWidget {
  final String url;
  const InlineAudioPlayer({Key? key, required this.url}) : super(key: key);

  @override
  State<InlineAudioPlayer> createState() => _InlineAudioPlayerState();
}

class _InlineAudioPlayerState extends State<InlineAudioPlayer> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription? _durationSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _playerStateSub;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setUrl(widget.url);
      _durationSub = _player.durationStream.listen((d) {
        if (mounted) setState(() => _duration = d ?? Duration.zero);
      });
      _positionSub = _player.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      });
      _playerStateSub = _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            if (state.processingState == ProcessingState.completed) {
              _position = Duration.zero;
              _player.seek(Duration.zero);
              _player.pause();
            }
          });
        }
      });
    } catch (e) {
      debugPrint("InlineAudioPlayer init error: $e");
    }
  }

  @override
  void dispose() {
    _durationSub?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_isPlaying) {
                _player.pause();
              } else {
                _player.play();
              }
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryCustom,
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.0,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 10.0),
                    activeTrackColor: AppColors.primaryCustom,
                    inactiveTrackColor: Colors.black12,
                    thumbColor: AppColors.primaryCustom,
                  ),
                  child: Slider(
                    min: 0.0,
                    max: _duration.inMilliseconds.toDouble() > 0
                        ? _duration.inMilliseconds.toDouble()
                        : 1.0,
                    value: _position.inMilliseconds.toDouble().clamp(
                        0.0,
                        _duration.inMilliseconds.toDouble() > 0
                            ? _duration.inMilliseconds.toDouble()
                            : 1.0),
                    onChanged: (value) {
                      _player.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black54),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black54),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InlineVideoPlayer extends StatefulWidget {
  final String url;
  final VoidCallback? onDownload;
  const InlineVideoPlayer({Key? key, required this.url, this.onDownload})
      : super(key: key);

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await _videoPlayerController.initialize();
      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        allowPlaybackSpeedChanging: false,
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primaryCustom,
          handleColor: AppColors.primaryCustom,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white54,
        ),
      );
      setState(() {});
    } catch (e) {
      debugPrint("InlineVideoPlayer init error: $e");
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        width: 280,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.broken_image, size: 40, color: Colors.black26),
            SizedBox(height: 8),
            Text("Failed to load video",
                style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      );
    }

    if (_chewieController == null) {
      return Container(
        width: 280,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      );
    }

    return Container(
      width: 280,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Chewie(
                controller: _chewieController!,
              ),
            ),
            // if (widget.onDownload != null)
            //   Positioned(
            //     top: 8,
            //     right: 8,
            //     child: GestureDetector(
            //       onTap: widget.onDownload,
            //       child: Container(
            //         padding: const EdgeInsets.all(6),
            //         decoration: BoxDecoration(
            //           color: Colors.black.withOpacity(0.5),
            //           shape: BoxShape.circle,
            //         ),
            //         child: const Icon(
            //           Icons.download_rounded,
            //           color: Colors.white,
            //           size: 20,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

class ChatShimmerLoading extends StatelessWidget {
  const ChatShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildShimmerRow(alignLeft: true, width: 140, height: 40),
          _buildShimmerRow(alignLeft: false, width: 200, height: 50),
          _buildShimmerRow(alignLeft: true, width: 180, height: 40),
          _buildShimmerRow(alignLeft: false, width: 120, height: 42),
          _buildShimmerRow(alignLeft: true, width: 220, height: 56),
          _buildShimmerRow(alignLeft: false, width: 160, height: 40),
        ],
      ),
    );
  }

  Widget _buildShimmerRow(
      {required bool alignLeft,
      required double width,
      required double height}) {
    return Align(
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (alignLeft) ...[
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            shimmerBox(
              height: height,
              width: width,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(alignLeft ? 0 : 16),
                bottomRight: Radius.circular(alignLeft ? 16 : 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
