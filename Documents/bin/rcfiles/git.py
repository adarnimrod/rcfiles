"""Git repository related functions."""

import configparser
import os.path
import pathlib
import sh  # pylint: disable=import-error
from sh.contrib import git  # pylint: disable=import-error


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


def get_all_remotes():
    """Return a dictionary of remotes and their URL.

    If not in a Git repository, return None.
    """
    if not in_repo:
        return None

    config = configparser.ConfigParser()
    config.read(".git/config")

    remotes = {
        x.removeprefix('remote "').removesuffix('"'): {
            "url": config[x]["url"],
            "name": x.removeprefix('remote "').removesuffix('"'),
        }
        for x in config.sections()
        if x.startswith("remote ")
    }

    return remotes


def add_remote(repo, name, url):
    """Add a remote to the Git repository."""
    with sh.pushd(repo):
        try:
            git.remote("add", name, url)
        except sh.ErrorReturnCode_3:
            git.remote("set-url", name, url)
        git.fetch(name)


def author_name():
    """Get the author name."""
    if "GIT_AUTHOR_NAME" in os.environ:
        return os.environ["GIT_AUTHOR_NAME"].strip()
    return git.config("--get", "user.name").strip()


def author_email():
    """Get the author email."""
    if "GIT_AUTHOR_EMAil" in os.environ:
        return os.environ["GIT_AUTHOR_EMAIL"].strip()
    return git.config("--get", "user.email").strip()


def empty_commit(repo):
    """Commits an empty commit and pushes."""
    with sh.pushd(repo):
        git.commit(
            "--allow-empty", "--only", "--message", "Initial empty commit."
        )
        git.push()
