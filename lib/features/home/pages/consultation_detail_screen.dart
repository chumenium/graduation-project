import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/consultation_model.dart';
import '../../../data/services/consultation_service.dart';
import '../../../features/mypage/provider/user_profile_provider.dart';

class ConsultationDetailScreen extends StatefulWidget {
  final Consultation consultation;
  const ConsultationDetailScreen({Key? key, required this.consultation})
      : super(key: key);

  @override
  State<ConsultationDetailScreen> createState() =>
      _ConsultationDetailScreenState();
}

class _Comment {
  final String userId;
  final String userName;
  final String userIconUrl;
  final String text;
  final bool isOwner;
  _Comment(
      {required this.userId,
      required this.userName,
      required this.userIconUrl,
      required this.text,
      required this.isOwner});
}

class _ConsultationDetailScreenState extends State<ConsultationDetailScreen> {
  final ConsultationService _consultationService = ConsultationService();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  List<_Comment> comments = [
    _Comment(
        userId: '1',
        userName: '出品者',
        userIconUrl: '',
        text: 'もちろんです。',
        isOwner: true),
    _Comment(
        userId: '2',
        userName: 'ユーザーA',
        userIconUrl: '',
        text: '詳細を教えてください',
        isOwner: false),
  ];

  bool _isLoading = false;
  bool _isInterested = false;

  @override
  void initState() {
    super.initState();
    _loadConsultationData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadConsultationData() async {
    // 閲覧数を増加
    try {
      await _consultationService.incrementViewCount(widget.consultation.id);
    } catch (e) {
      print('閲覧数の更新に失敗: $e');
    }

    // 現在のユーザーが興味を示しているかチェック
    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    final currentUserId = userProfileProvider.currentUserId;
    if (currentUserId != null) {
      setState(() {
        _isInterested = widget.consultation.interestedUsers.contains(currentUserId);
      });
    }
  }

  Future<void> _toggleInterest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _consultationService.toggleInterest(widget.consultation.id);
      setState(() {
        _isInterested = !_isInterested;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isInterested ? '興味を示しました' : '興味を削除しました'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('操作に失敗しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _takeRequest() async {
    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    final currentUserId = userProfileProvider.currentUserId;
    
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ログインが必要です'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (currentUserId == widget.consultation.authorId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('自分の相談は依頼できません'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 依頼を受ける処理（ここでは相談を進行中に変更）
    setState(() {
      _isLoading = true;
    });

    try {
      await _consultationService.markAsInProgress(widget.consultation.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('依頼を受けました！'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('依頼に失敗しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}日前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}時間前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分前';
    } else {
      return '今';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'solved':
        return Colors.blue;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'open':
        return '公開中';
      case 'in_progress':
        return '進行中';
      case 'solved':
        return '解決済み';
      case 'closed':
        return '終了';
      default:
        return '不明';
    }
  }

  @override
  Widget build(BuildContext context) {
    final consultation = widget.consultation;
    final theme = Theme.of(context);
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final currentUserId = userProfileProvider.currentUserId;
    final isOwner = currentUserId == consultation.authorId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('相談詳細'),
        backgroundColor: theme.appBarTheme.backgroundColor ??
            theme.colorScheme.surface,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.red),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            tooltip: '通知',
          ),
          IconButton(
            icon: const Icon(Icons.forum, color: Colors.red),
            onPressed: () {
              Navigator.pushNamed(context, '/transactions');
            },
            tooltip: 'やり取り中',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.red),
            onPressed: () {
              Navigator.pushNamed(context, '/profile_settings');
            },
            tooltip: 'プロフィール',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル
            Text(consultation.title,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color)),
            const SizedBox(height: 12),
            
            // ステータスとカテゴリ
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(consultation.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(consultation.status),
                    style: TextStyle(
                      color: _getStatusColor(consultation.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(consultation.category,
                      style: TextStyle(color: theme.colorScheme.primary)),
                  backgroundColor: theme.brightness == Brightness.dark
                      ? Colors.blueGrey[900]
                      : Colors.blue[50],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // 投稿者情報
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  backgroundImage: consultation.authorPhotoURL != null
                      ? NetworkImage(consultation.authorPhotoURL!)
                      : null,
                  child: consultation.authorPhotoURL == null
                      ? Icon(Icons.person, color: theme.iconTheme.color)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultation.authorName ?? '匿名ユーザー',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      Text(
                        _formatDate(consultation.createdAt),
                        style: TextStyle(color: theme.hintColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (consultation.budget > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '¥${consultation.budget.toString()}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 相談内容
            Text('相談内容',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Text(
                consultation.description,
                style: TextStyle(
                    fontSize: 16,
                    color: theme.textTheme.bodyLarge?.color),
              ),
            ),
            
            // タグ
            if (consultation.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('タグ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: consultation.tags.map((tag) => Chip(
                  label: Text(tag),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // 統計情報
            Row(
              children: [
                Icon(Icons.visibility, size: 16, color: theme.hintColor),
                const SizedBox(width: 4),
                Text(
                  '${consultation.viewCount} 閲覧',
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.favorite_border, size: 16, color: theme.hintColor),
                const SizedBox(width: 4),
                Text(
                  '${consultation.interestedUsers.length} 興味',
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // アクションボタン
            if (!isOwner && consultation.isOpen) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _toggleInterest,
                      icon: Icon(_isInterested ? Icons.favorite : Icons.favorite_border),
                      label: Text(_isInterested ? '興味済み' : '興味を示す'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isInterested ? Colors.red : null,
                        foregroundColor: _isInterested ? Colors.white : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _takeRequest,
                      child: const Text('依頼を受ける'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // オーナーの場合のステータス変更ボタン
            if (isOwner && consultation.isOpen) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () async {
                        try {
                          await _consultationService.markAsSolved(consultation.id);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('解決済みにマークしました')),
                            );
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('エラー: $e')),
                            );
                          }
                        }
                      },
                      child: const Text('解決済みにする'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () async {
                        try {
                          await _consultationService.closeConsultation(consultation.id);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('相談を終了しました')),
                            );
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('エラー: $e')),
                            );
                          }
                        }
                      },
                      child: const Text('終了する'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // コメントセクション
            const Text('コメント', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4),
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: false,
                  itemCount: comments.length,
                  itemBuilder: (context, idx) {
                    final c = comments[idx];
                    return Align(
                      alignment: c.isOwner
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(10),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: c.isOwner
                              ? (theme.brightness == Brightness.dark
                                  ? Colors.blue[900]
                                  : Colors.blue[50])
                              : (theme.brightness == Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.grey[200]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.userName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: theme.hintColor)),
                            const SizedBox(height: 4),
                            Text(c.text,
                                style: TextStyle(
                                    color: theme.textTheme.bodyLarge?.color)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // コメント入力
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'コメントを入力...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // コメント投稿処理（実装予定）
                    if (_commentController.text.isNotEmpty) {
                      setState(() {
                        comments.add(_Comment(
                          userId: 'current',
                          userName: '現在のユーザー',
                          userIconUrl: '',
                          text: _commentController.text,
                          isOwner: false,
                        ));
                      });
                      _commentController.clear();
                    }
                  },
                  child: const Text('送信'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
