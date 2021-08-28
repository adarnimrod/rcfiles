"""A bunch of convenience functions to deal with GitLab."""

import os
import re
import gitlab  # pylint: disable=import-error


def name_to_path(name):
    """Converts a name to valid path in GitLab."""
    return re.sub("[^a-zA-Z0-9_-]", "-", name).lower()


def get_url():
    """Return the GitLab URL."""
    return os.getenv(
        "GITLAB_BASE_URL", "https://git.shore.co.il/"
    ).removesuffix("api/v4")


def connect():
    """Return the GitLab object."""
    try:
        token = os.environ["GITLAB_TOKEN"]
    except KeyError:
        raise Exception("GITLAB_TOKEN environment variable not set.")
    url = get_url()
    conn = gitlab.Gitlab(url=url, private_token=token)
    conn.auth()
    return conn


def get_group(conn, name):
    """Return the GitLab group object with the given name."""
    for group in conn.groups.list(all=True):
        if group.name == name:
            return group
    return None


def create_group(conn, name, visibility=None, description=None):
    """Create a new GitLab group and return that object."""
    data = {
        "name": name,
        "path": name_to_path(name),
        "visibility": "public" if visibility is None else visibility,
    }
    if description is not None:
        data["description"] = description
    return conn.groups.create(data)


def get_project(conn, group, name):
    """Returns a GitLab project."""
    # pylint: disable=invalid-name
    g = get_group(conn, group)
    if g is None:
        return None
    for p in g.projects.list(all=True):
        if p.name == name:
            return p
    return None


def create_project(conn, name, group=None, description=None, visibility=None):
    """Create a new GitLab project and return that object."""
    # pylint: disable=invalid-name
    data = {
        "name": name,
    }
    if group is not None:
        g = get_group(conn, group)
        if g is None:
            return None
        data["namespace_id"] = g.id
    if description is not None:
        data["description"] = description
    if visibility is not None:
        data["visibility"] = visibility
    return conn.projects.create(data)
