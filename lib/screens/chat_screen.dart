import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:criterium/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:criterium/providers/app_provider.dart';

class ChatScreen extends StatefulWidget {
  final String studentName;
  final String studentAvatar;

  const ChatScreen({
    super.key,
    required this.studentName,
    required this.studentAvatar,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AppProvider>().fetchAppData());
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    final timeStr = '$hour:${now.minute.toString().padLeft(2, '0')} $period';

    context.read<AppProvider>().sendMessage(widget.studentName, text, timeStr);
    _msgController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
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
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : AppTheme.navyBlue;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: CachedNetworkImageProvider(widget.studentAvatar),
              backgroundColor: AppTheme.navyBlue.withOpacity(0.08),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.studentName,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'En línea',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2ECC71),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: context.watch<AppProvider>().isLoading
                ? const Center(child: CircularProgressIndicator())
                : context.watch<AppProvider>().errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.watch<AppProvider>().errorMessage!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<AppProvider>().fetchAppData(),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: context
                        .watch<AppProvider>()
                        .getChatFor(widget.studentName)
                        .length,
                    itemBuilder: (context, index) {
                      final chatMessages = context
                          .watch<AppProvider>()
                          .getChatFor(widget.studentName);
                      final msg = chatMessages[index];
                      final isMe = msg['isMe'] as bool;
                      return _buildBubble(
                        context,
                        msg['text'] as String,
                        msg['time'] as String,
                        isMe,
                      );
                    },
                  ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Escribir un mensaje...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFF3F4F6),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0D47A1), Color(0xFF00AA88)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(
    BuildContext context,
    String text,
    String time,
    bool isMe,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.navyBlue : cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isMe
                    ? Colors.white
                    : (isDark ? Colors.white : AppTheme.navyBlue),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: isMe ? Colors.white.withOpacity(0.6) : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
