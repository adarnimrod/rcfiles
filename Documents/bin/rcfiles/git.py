"""Git repository related functions."""

import os.path
import pathlib


def is_repo(path):
    """Returns a boolean if the path is a Git repo."""
    return os.path.isdir(path) and pathlib.Path(path, ".git").is_dir()


def in_repo():
    """Is the current working directory a git repo?

    Because we invoke the command as a Git command (git foo) it is run from
    the root of the repository if inside a repository so there's no need to
    traverse up the directory hierarchy to find if we're in a Git repository,
    it's enough to just check if the .git directory exists where we are.
    """
    return is_repo(".")
