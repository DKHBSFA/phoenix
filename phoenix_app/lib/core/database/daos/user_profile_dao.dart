import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'user_profile_dao.g.dart';

@DriftAccessor(tables: [UserProfiles])
class UserProfileDao extends DatabaseAccessor<PhoenixDatabase>
    with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  Future<UserProfile?> getProfile() {
    return (select(userProfiles)..limit(1)).getSingleOrNull();
  }

  Stream<UserProfile?> watchProfile() {
    return (select(userProfiles)..limit(1)).watchSingleOrNull();
  }

  Future<void> saveProfile(UserProfilesCompanion data) async {
    final existing = await getProfile();
    if (existing != null) {
      await (update(userProfiles)..where((p) => p.id.equals(existing.id)))
          .write(data.copyWith(updatedAt: Value(DateTime.now())));
    } else {
      final now = DateTime.now();
      await into(userProfiles).insert(data.copyWith(
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
    }
  }

  Future<bool> isOnboardingComplete() async {
    final profile = await getProfile();
    return profile?.onboardingComplete ?? false;
  }

  Future<void> updateWeight(double kg) async {
    final profile = await getProfile();
    if (profile != null) {
      await (update(userProfiles)..where((p) => p.id.equals(profile.id)))
          .write(UserProfilesCompanion(
        weightKg: Value(kg),
        updatedAt: Value(DateTime.now()),
      ));
    }
  }
}
