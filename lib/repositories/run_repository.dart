import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/run.dart';
import 'base_repository.dart';

class RunRepository extends BaseRepository {
  CollectionReference getUserRunsCollection(String userId) {
    return firestore.collection('users/$userId/runs');
  }

  Future<String> addRun(String userId, Run run) async {
    final docRef = await getUserRunsCollection(userId).add(run.toJson());
    return docRef.id;
  }

  Future<List<Run>> getRunsByUserId(String userId) {
    return getUserRunsCollection(userId)
        .get()
        .then((querySnapshot) => querySnapshot.docs
        .map((doc) => Run.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<bool> deleteRun(String userId, String runId) async {
    try {
      await getUserRunsCollection(userId).doc(runId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Run> updateRun(String userId, String runId, Run run) async {
    try {
      await getUserRunsCollection(userId).doc(runId).update(run.toJson());
      return run;
    } catch (e) {
      rethrow;
    }
  }

  Future<Run?> getRunById(String userId, String runId) async {
    try {
      final docSnapshot = await getUserRunsCollection(userId).doc(runId).get();
      if (docSnapshot.exists) {
        return Run.fromJson(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Run> addRoutePointByUserIdAndRunId(String userId, String runId, RoutePoint routePoint) async {
    try {
      final run = await getRunById(userId, runId);
      if (run == null) {
        throw Exception('Run not found');
      }
      run.route.add(routePoint);
      await updateRun(userId, runId, run);
      return run;
    } catch (e) {
      rethrow;
    }
  }
}