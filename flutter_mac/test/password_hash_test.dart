import 'package:flutter_test/flutter_test.dart';
import 'package:fromchat_mac/crypto/password_hash.dart';

void main() {
  test('deriveAuthSecret is stable', () {
    final a = PasswordHash.deriveAuthSecret('alice', 'secret');
    final b = PasswordHash.deriveAuthSecret('alice', 'secret');
    final c = PasswordHash.deriveAuthSecret('bob', 'secret');
    expect(a, b);
    expect(a, isNot(c));
    expect(a.length, greaterThan(20));
  });
}
