"""A bunch of convenience functions to deal with GitLab."""

import os
import re
import gitlab  # pylint: disable=import-error,useless-suppression
import gitlab.exceptions  # pylint: disable=import-error
from . import git


def http_url(conn):
    """Return the HTTP url to the GitLab instance."""
    return conn.get_url()


def ssh_url(conn):
    """Return the SSH url to the GitLab instance."""
    return f'git@{http_url(conn).removeprefix("https://").removesuffix("/")}:'


def url_to_name(conn, url):
    """Get the full name from the GitLab URL."""
    return (
        url.removeprefix(http_url(conn))
        .removeprefix(ssh_url(conn.git))
        .removesuffix("/")
        .removesuffix(".git")
    )


def is_gitlab_url(conn, url):
    """Return is the URL for a GitLab repository."""
    return url.startswith(http_url(conn)) or url.startswith(ssh_url(conn))


def name_to_path(name):
    """Converts a name to valid path in GitLab."""
    return re.sub("[^a-zA-Z0-9_-]", "-", name).lower()


def get_url():
    """Return the GitLab URL."""
    return os.getenv(
        "GITLAB_BASE_URL", "https://git.shore.co.il/"
    ).removesuffix("api/v4")


def get_remotes(conn):
    """Returns a list of all the GitLab remotes.

    Very similar to the get_all_remotes function from the general git module,
    but just the GitLab remotes and a bit more information.
    """
    remotes = git.get_all_remotes()
    if remotes is None:
        return None

    gl_remotes = {
        name: remote
        for name, remote in remotes.items()
        if is_gitlab_url(conn, remote["url"])
    }
    for name, remote in gl_remotes.items():
        try:
            gl_remotes[name]["project"] = conn.projects.get(
                url_to_name(conn, remote["url"])
            )
        except gitlab.exceptions.GitlabGetError:
            pass

    return gl_remotes


def connect():
    """Return the GitLab object."""
    try:
        token = os.environ["GITLAB_TOKEN"]
    except KeyError:
        # pylint: disable-next=raise-missing-from
        raise Exception("GITLAB_TOKEN environment variable not set.")
    url = get_url()
    conn = gitlab.Gitlab(url=url, private_token=token)
    conn.auth()
    return conn


# pylint: disable=invalid-name
def me(conn):
    """Return my GitLab account name."""
    return conn.user.username


def empty_commit(project):
    """Commit an empty commit."""
    return project.commit.create(
        {
            "id": project.id,
            "branch": project.default_branch,
            "commit_message": "Initial empty commit.",
            "actions": [],
            "author_email": git.author_email(),
            "author_name": git.author_name(),
        }
    )
