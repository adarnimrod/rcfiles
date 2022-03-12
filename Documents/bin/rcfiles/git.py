"""Git repository related functions."""

import configparser
import os.path
import pathlib

import sh  # pylint: disable=import-error
from sh.contrib import git  # pylint: disable=import-error


def is_repo(path):
    """Returns a boolean if the path is a Git repo."""
    try:
        git("-C", path, "rev-parse", "--is-inside-work-tree")
    except sh.ErrorReturnCode:
        return False
    return True


def in_repo():
    """Is the current working directory a git repo?"""
    return is_repo(".")


def find_repo_toplevel(path):
    """Return the repository's top level directory (the root of the repo)."""
    if not is_repo(path):
        return None
    return pathlib.Path(
        git("-C", path, "rev-parse", "--show-toplevel").strip()
    )


def get_all_remotes():
    """Return a dictionary of remotes and their URL.

    If not in a Git repository, return None.
    """
    if not in_repo:
        return None

    config = configparser.ConfigParser()
    config.read(find_repo_toplevel(".") / ".git/config")

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
