# untruth-instagram-followers

Totally \*legal\* Instagram automation. Crosses a user follower/following data to find who he follows, but that doesn't follow him.

## Running

This automation is done in Dart, so make sure to get Dart SDK in order to run it in whatever environment you are on. Else you can always execute the binary available in `bin` folder if you are under a x64 Linux environment.

Running is as simple as:

```
> dart run

Welcome to untruth-instagram-followers! Below are the mandatory arguments you need to specify.
-u, --username (mandatory)     Specifies the username credential to login in Instagram
-p, --password (mandatory)     Specifies the password credential to login in Instagram
-i, --profileid (mandatory)    Specifies the ID of the user profile which data is getting scrapped
-m, --mode                     Specifies the output mode (text, markdown) which results will be formatted
                               (defaults to "text")
-h, --[no-]headful             Specifies whether the automation should run in headful or headless mode. (defaults to headless)
```

### Notes

- Be sure to do this on a throwaway account (totally legal)
- You can get a user profile ID by opening networking tab of your browser dev-console, and then open the followers list of the target user. The `count` endpoint request is followed by the user ID.
- This was done with some Portuguese labels, so if you are not Portuguese, the automation will fail on the beggining (I'm still working on this).

### Demo (headful mode)

https://user-images.githubusercontent.com/26190214/182692365-8d807384-e354-4893-8ec7-805a3b74e407.mp4
