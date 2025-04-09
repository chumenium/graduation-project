import '../models/consultation_model.dart';

class ConsultationService {
  final List<Consultation> _mockList = [
    Consultation(
      id: '1',
      title: 'Flutterで画面遷移ができない',
      category: 'プログラミング',
      description: 'Navigatorで画面遷移しようとするとエラーになります。',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Consultation(
      id: '2',
      title: 'ノートPCの動作が遅い',
      category: 'PCトラブル',
      description: 'タスクマネージャーの見方を教えてください。',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<void> addConsultation(Consultation consultation) async {
    // 🔸 本来はFirebaseのadd()を使用予定
    await Future.delayed(const Duration(milliseconds: 300));
    _mockList.insert(0, consultation);
  }
}
