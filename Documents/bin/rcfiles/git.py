"""Git repository related functions."""

import configparser
import os.path
import pathlib
from sh.contrib import git  # pylint: disable=import-error
from . import gitlab


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


def get_remotes():
    """Return a dictionary of remotes and their URL.
    Also, deduce the remote type ("gitlab", "github" or None if couldn't figure
    it out) and get the namespace and repository name.

    If not in a Git repository, return None.
    """
    if not in_repo:
        return None

    gitlab_http_url = gitlab.get_url()
    gitlab_ssh_url = (
        f'git@{gitlab_http_url.removeprefix("https://").removesuffix("/")}:'
    )
    github_http_url = "https://github.com/"
    github_ssh_url = "git@github.com:"

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

    for name, remote in remotes.items():
        if remote["url"].startswith(gitlab_http_url) or remote[
            "url"
        ].startswith(gitlab_ssh_url):
            remotes[name]["type"] = "gitlab"
            parts = (
                remote["url"]
                .removeprefix(gitlab_http_url)
                .removeprefix(gitlab_ssh_url)
                .removesuffix(".git")
                .split("/")
            )
            if len(parts) == 2:
                remotes[name]["namespace"] = parts[0]
                remotes[name]["name"] = parts[1]
        elif remote["url"].startswith(github_http_url) or remote[
            "url"
        ].startswith(github_ssh_url):
            remotes[name]["type"] = "github"
            parts = (
                remote["url"]
                .removeprefix(github_http_url)
                .removeprefix(github_ssh_url)
                .removesuffix(".git")
                .split("/")
            )
            if len(parts) == 2:
                remotes[name]["name"] = parts[1]
        else:
            remotes[remote]["type"] = None

    return remotes


def add_remote(name, url):
    """Add a remote to the Git repository."""
    git.remote("add", name, url)
