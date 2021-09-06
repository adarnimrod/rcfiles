"""A bunch of convenience functions to deal with GitHub."""

import os
import github3  # pylint: disable=import-error

# from . import git

HTTP_URL = "https://github.com/"
SSH_URL = "git@github.com:"


def url_to_name(url):
    """Get the full name from the GitLab URL."""
    return (
        url.removeprefix(HTTP_URL)
        .removeprefix(SSH_URL)
        .removesuffix("/")
        .removesuffix(".git")
    )


def is_github_url(url):
    """Return is the URL for a GitHub repository."""
    return url.startswith(HTTP_URL) or url.startswith(SSH_URL)


def connect():
    """Return a GitHub session."""
    try:
        token = os.environ["GITHUB_TOKEN"]
    except KeyError:
        # pylint: disable-next=raise-missing-from
        raise Exception("GITHUB_TOKEN environment variable not set.")
    return github3.login(token=token)


# pylint: disable=invalid-name
def me(conn):
    """Return my GitHub account name."""
    return conn.me().login


def empty_commit(repository):
    """Commit an empty commit."""
    raise NotImplementedError
