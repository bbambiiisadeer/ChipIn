import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../local_storage.dart'; 
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- ฟังก์ชันกลางสำหรับจัดการข้อมูล User ให้เป็นรูปแบบเดียวกัน ---
  Future<void> _updateUserData(User user, String provider, {String? customUsername}) async {
    final userRef = _firestore.collection('users').doc(user.uid);

    await userRef.set(
      {
        'uid': user.uid,
        'email': user.email,
        // ถ้ามีการส่ง username มาจากหน้า Sign Up ให้ใช้ค่านั้น ถ้าไม่มีให้ใช้ชื่อจาก Provider
        'username': customUsername ?? user.displayName ?? user.email?.split('@')[0] ?? 'User',
        'auth_provider': provider,
        'created_at': FieldValue.serverTimestamp(), 
        'average_rating': 0.0,
      },
      SetOptions(merge: true),
    );
  }

  // ฟังก์ชันสมัครสมาชิก (Sign Up)
  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      print(">>> เริ่มสร้างบัญชี...");
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // เรียกใช้ฟังก์ชันกลาง และส่ง username ที่ผู้ใช้กรอกเองเข้าไปด้วย
      await _updateUserData(result.user!, 'email', customUsername: username);
      
      print(">>> สร้างและบันทึกข้อมูลสำเร็จ: ${result.user?.uid}");
      return null;
    } catch (e) {
      print(">>> พบข้อผิดพลาด: $e");
      return e.toString();
    }
  }

  // ฟังก์ชันเข้าสู่ระบบ (Login)
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await LocalStorage.saveLoginStatus(true);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // เรียกใช้ฟังก์ชันกลาง (ใช้ merge: true ภายในจะช่วยให้ไม่ทับข้อมูลเก่าถ้าเคยล็อกอินแล้ว)
      await _updateUserData(userCredential.user!, 'google');

      return userCredential;
    } catch (e) {
      print("Error Google Sign-In: $e");
      return null;
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);
        await LocalStorage.saveLoginStatus(true);

        // เรียกใช้ฟังก์ชันกลาง
        await _updateUserData(userCredential.user!, 'facebook');

        return userCredential;
      } else {
        return null;
      }
    } catch (e) {
      print("Error Facebook Sign-In: $e");
      return null;
    }
  }

  // ฟังก์ชันออกจากระบบ (Logout)
  Future<void> logout() async {
    await _auth.signOut();
    await LocalStorage.saveLoginStatus(false);
  }
}