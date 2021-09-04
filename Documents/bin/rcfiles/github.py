"""A bunch of convenience functions to deal with GitHub."""

import os
import github3  # pylint: disable=import-error


def connect():
    """Return a GitHub session."""
    try:
        token = os.environ["GITHUB_TOKEN"]
    except KeyError:
        raise Exception("GITHUB_TOKEN environment variable not set.")
    return github3.login(token=token)


def github_me(conn):
    """Return my GitHub account name."""
    return conn.me().login


def create_repo(  # pylint: disable=too-many-arguments
    conn, name, description="", homepage="", has_issues=False, has_wiki=False
):
    """Create a new GitHub repository under the login namespace."""
    return conn.create_repository(
        name, description, homepage, has_issues=has_issues, has_wiki=has_wiki
    )


def get_repo(conn, name):
    """Return the GitHub repo object with the given name."""
    me = github_me(conn)  # pylint: disable=invalid-name
    for i in conn.repositries_by(me, type="owner"):
        if i.name == name:
            return i
    raise Exception(f"Could not find the {name} GitHub repository.")


def read_only_github(conn, name):
    """Make a GitHub repository read-only."""
    repo = get_repo(conn, name)
    repo.edit(name, archived=True)
