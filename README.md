# Git it up 💁

Keeps your git repository in sync with the remote. Useful, for example, for keeping a simple repository on a server up-to-date.

## Usage

First, create a file that lists directories with Git repositories that you want to keep up-to-date. *Location is relative to where you are going to run the script from.*

```
my_fancy_project/repo_1
my_fancy_project/repo_2
../another_project
```

Then you just run the script and pass it the location of the file you just created:

```bash
$ nohup ruby update.rb --list=repo_list.txt > /dev/null 2>&1 &
```
