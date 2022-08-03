import 'package:puppeteer/puppeteer.dart';
import 'package:untruth_instagram_followers/models/user.dart';

Future<Set<User>> fetchAllUsers({
  required final String profileId,
  required final Page page,
  final bool following = true,
  final Duration delayBetweenRequests = const Duration(milliseconds: 2500),
}) async {
  final users = <User>[];

  final usersEndpoint = following ? 'following' : 'followers';

  var canRequestMoreUsers = true;

  Future<dynamic> fetchUsers() {
    final fetchLimit = 200;
    final maxIdQueryParameter =
        users.isNotEmpty ? '&max_id=${users.length}' : '';

    final fetchUrl =
        'https://i.instagram.com/api/v1/friendships/$profileId/$usersEndpoint/?count=$fetchLimit$maxIdQueryParameter';

    print('Fetching: $fetchUrl');

    return page.evaluate(
      '''()=>{
      return fetch("$fetchUrl", {
        "headers": {
        "x-ig-app-id": "936619743392459"
        },
        "referrer": "https://www.instagram.com/",
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": null,
        "method": "GET",
        "mode": "cors",
        "credentials": "include"
      }).then((r) => r.json());
}''',
    );
  }

  while (canRequestMoreUsers) {
    final response = await fetchUsers();

    if (response is Map) {
      canRequestMoreUsers = response.containsKey('next_max_id');

      final usersJson = response['users'] as List<dynamic>;

      users.addAll(usersJson.map(((e) => User.fromJson(e))));
    } else {
      canRequestMoreUsers = false;
    }

    if (canRequestMoreUsers) {
      await Future.delayed(delayBetweenRequests);
    }
  }

  return Set.from(users);
}
