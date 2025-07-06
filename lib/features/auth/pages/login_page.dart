import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/models/user_profile.dart';
import '../../../features/mypage/provider/user_profile_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  // Web用のGoogleSignIn設定
  final _googleSignIn = GoogleSignIn(
    clientId: '8232723901-13rqnlkgdg37aiimf2cp95iad1fmrcg3.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );
  final _firestoreService = FirestoreService();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Googleサインイン
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 既存のサインインをクリア
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // IDトークンが取得できない場合の処理
      if (googleAuth.idToken == null) {
        throw Exception('IDトークンが取得できませんでした。');
      }
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // ユーザープロフィールを作成または更新
        await _createOrUpdateUserProfile(user);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Googleサインインに成功しました！'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacementNamed('/');
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Googleサインインに失敗しました';
        
        if (e.toString().contains('popup_closed')) {
          errorMessage = 'サインインがキャンセルされました';
        } else if (e.toString().contains('IDトークン')) {
          errorMessage = 'IDトークンの取得に失敗しました。';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // メール/パスワードでサインアップ
  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = userCredential.user;
      if (user != null) {
        // ユーザープロフィールを作成
        await _createOrUpdateUserProfile(user);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('アカウントを作成しました！'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacementNamed('/');
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'サインアップに失敗しました';
      if (e.code == 'weak-password') {
        message = 'パスワードが弱すぎます（6文字以上）';
      } else if (e.code == 'email-already-in-use') {
        message = 'このメールアドレスは既に使用されています';
      } else if (e.code == 'invalid-email') {
        message = '無効なメールアドレスです';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('サインアップに失敗しました: $e'),
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

  // メール/パスワードでサインイン
  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = userCredential.user;
      if (user != null) {
        // ユーザープロフィールを取得して更新
        await _createOrUpdateUserProfile(user);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ログインに成功しました！'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacementNamed('/');
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'サインインに失敗しました';
      if (e.code == 'user-not-found') {
        message = 'ユーザーが見つかりません。新規登録してください。';
      } else if (e.code == 'wrong-password') {
        message = 'パスワードが間違っています';
      } else if (e.code == 'invalid-email') {
        message = '無効なメールアドレスです';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('サインインに失敗しました: $e'),
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

  // ユーザープロフィールを作成または更新
  Future<void> _createOrUpdateUserProfile(User user) async {
    try {
      // 既存のプロフィールを確認
      UserProfile? existingProfile = await _firestoreService.getUserProfile(user.uid);
      
      if (existingProfile == null) {
        // 新しいプロフィールを作成
        final newProfile = UserProfile(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoURL: user.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _firestoreService.createUserProfile(newProfile);
        
        // Providerを更新
        if (mounted) {
          final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
          userProfileProvider.setUserProfile(newProfile);
        }
      } else {
        // 既存のプロフィールを更新（認証情報が変更された場合）
        final updatedProfile = existingProfile.copyWith(
          displayName: user.displayName ?? existingProfile.displayName,
          photoURL: user.photoURL ?? existingProfile.photoURL,
        );
        
        await _firestoreService.updateUserProfile(updatedProfile);
        
        // Providerを更新
        if (mounted) {
          final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
          userProfileProvider.setUserProfile(updatedProfile);
        }
      }
    } catch (e) {
      print('ユーザープロフィールの作成/更新に失敗: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // アプリロゴ・タイトル
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '相談マッチングアプリ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'あなたの相談を解決しましょう',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ログインフォーム
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'メールアドレス',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'メールアドレスを入力してください';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return '有効なメールアドレスを入力してください';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'パスワード',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'パスワードを入力してください';
                            }
                            if (value.length < 6) {
                              return 'パスワードは6文字以上で入力してください';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // サインインボタン
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signInWithEmail,
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text('サインイン'),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // サインアップボタン
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _signUpWithEmail,
                            child: const Text('新規登録'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // または
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('または'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Googleサインインボタン
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _signInWithGoogle,
                      icon: const Icon(Icons.g_mobiledata, size: 24),
                      label: const Text('Googleでサインイン'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 