# CODING AGENT INSTRUCTIONS

- You're running inside a bubblewrap sandbox inside a container. If you're
  having access issues or if something is missing, let me know what is missing.

- The preference is _always_ for short and simple code and short and simple
  changes.

- Make the documentation short. The longer the documentation, the less useful
  it is.

- Instead of documentation, make the code more readable. Use meaningful names,
  add small function and variables that explain the process.

- Add comments in the code to note restrictions, limitation, decisions and
  everything that explains why the code is structured in a specific way.

- If you're making additional changes to complete a task, let me know what, why
  and where.

- Avoid using bashisms, use POSIX shell (accepted exceptions are ones that are
  valid on BusyBox shell, Debian Almquist Shell _and_ OpenBSD's Korn shell).

- To notify me, use `notify-send -a "Claude Code" "<title>" "<body>"` and put
  the session name in the title. A hook already notifies me after prompts that
  take over 30s (`~/.claude/hooks/notify-long-prompt.sh`). Use `/tmp` for temp
  files, `/run/user/1000` is read-only in the sandbox.

- Don't push changes or interact with GitHub without asking me directly first.

- When accessing AWS either directly or through a tool (like OpenTofu or
  Ansible), use the schoolinks-prod-readonly and schoolinks-dev-readonly AWS
  profiles (depending on which environment you on). If you need to use a
  different profile, ask directly first.
