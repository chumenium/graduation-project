import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('プライバシーポリシー')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(_privacyPolicyText, style: const TextStyle(fontSize: 14)),
        ),
      ),
    );
  }
}

const String _privacyPolicyText = '''
【プライバシーポリシー】

1. 取得する情報
本アプリは、ユーザー登録・ログイン・相談投稿・決済等の機能提供のため、以下の情報を取得します。
- 氏名、メールアドレス、プロフィール画像
- 相談内容、投稿履歴、取引履歴
- 決済情報（Stripe/PayPal等の外部サービス経由）
- 端末情報、アクセスログ、Cookie等

2. 利用目的
取得した情報は、以下の目的で利用します。
- 本サービスの提供・運営・本人確認
- 相談マッチング、決済、ポイント管理
- サポート・問い合わせ対応
- サービス改善・新機能開発・マーケティング
- 法令遵守・不正利用防止

3. 第三者提供
ユーザーの同意がある場合、または法令に基づく場合を除き、個人情報を第三者に提供しません。

4. 外部サービス連携
本アプリは、Google認証、Stripe/PayPal等の外部サービスと連携します。各サービスのプライバシーポリシーもご確認ください。

5. 安全管理
取得した情報は、SSL/TLS等の技術で安全に管理します。

6. 開示・訂正・削除
ユーザーは、自己の個人情報の開示・訂正・削除を求めることができます。問い合わせ窓口までご連絡ください。

7. 改定
本ポリシーは、必要に応じて改定することがあります。改定時はアプリ内で告知します。

8. お問い合わせ
個人情報の取扱いに関するお問い合わせは、運営者までご連絡ください。

附則：2025年4月10日 制定
''';
