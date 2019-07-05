# Secret Folder

Please note that this is a test implementation to see if I can remove the password from the database config that I realised was public. It was only public after I destroyed the database it was configured for, but it showed me that it was possible that a mistake is easily made.

This is going to be left open in case others want to see how I have done it.

## Securing

Ensure that the following is added to your .gitignore file to ensure that they are never checked in to a repo. Make sure that you back them up in a different way that is secure.

## Note
Using a % sign in one of the values does not work.


## Links
I found the following helpful in my research

https://docs.python.org/3/library/configparser.html

https://stackoverflow.com/questions/5055042/whats-the-best-practice-using-a-settings-file-in-python/5056829#5056829
https://stackoverflow.com/questions/52293453/how-to-keep-secret-key-information-out-of-git-repository