# Social Username Availability Checker

This project quickly checks the availability of usernames in the following Services without the need for API connections::

- YouTube
- Twitch
- Instagram
- TikTok
- Threads
- BlueSky

## Platform Support

This script was tested only in macOS and probably needs changes to run on other platforms. Feel free to do it.

## How to use

Clone the repository:
```bash
$ git clone https://github.com/mateuschmitz/social-username-checker.git
```

Run your search using the `check.sh` file that exists in the project:
```bash
$ check.sh testingusername
```

You can alternately create a symbolic link:
```bash
$ sudo ln -s <PROJECT_FOLDER>/check.sh /usr/local/bin/social-check
```

And use the project:
```bash
$ social-check testingusername
```

Output:
<p>
  <img src="https://ibb.co/yYCQfTm" />
</p>

If you need to check multiple usernames, you can pass a list of usernames as follows:
```bash
$ social-check /tmp/usernames_to_test.txt
```
P.S.: After each username, the script will insert a random sleep between 2 and 15 seconds.


## To Do

- [x] Insert YouTube availability check  
- [x] Insert Twitch availability check  
- [x] Insert Instagram availability check  
- [x] Insert TikTok availability check  
- [x] Insert Threads availability check  
- [x] Insert BlueSky availability check  
- [ ] Insert X/Twitter availability check  
