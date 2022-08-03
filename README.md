# untruth-instagram-followers

Totally \*legal\* Instagram automation. Crosses a user follower/following data to find who he follows, but that doesn't follow him.

## Running

This automation is done in Dart, so make sure to get Dart SDK in order to run it in whatever environment you are on. Else you can always execute the binary available in `bin` folder if you are under a x64 Linux environment.

The program expects the following three environment variables to be set:

|Variable|Description|
|--------|-----------|
|instagram_username|Username credential to login in Instagram|
|instagram_password|Password credential to login in Instagram|
|instagram_profile_id|ID of the user profile which data is getting scrapped|

Running is as simple as:

```
dart run
```

### Notes

- Be sure to do this on a throwaway account (totally legal)
- You can get a user profile ID by opening networking tab of your browser dev-console, and then open the followers list of the target user. The `count` endpoint request is followed by the user ID.
- This was done with some Portuguese labels, so if you are not Portuguese, the automation will fail on the beggining (I'm still working on this).