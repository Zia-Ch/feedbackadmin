import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/appwrite_constants.dart';

final appwriteCleintProvider = Provider((ref) {
  Client client = Client();
  client
      .setEndpoint(AppwriteConstants.endpoint)
      .setProject(AppwriteConstants.projectiD)
      .setSelfSigned(status: true);
  return client;
});

final appwriteAccountProvider =
    Provider((ref) => Account(ref.watch(appwriteCleintProvider)));

final appwriteDatabaseProvider =
    Provider((ref) => Databases(ref.watch(appwriteCleintProvider)));
