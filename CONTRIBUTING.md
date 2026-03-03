# Contributing

Thanks for considering a contribution.

## Getting started

1. Fork the repository.
2. Create a branch from `main`:
   - `feat/<short-description>` for features
   - `fix/<short-description>` for bug fixes
   - `docs/<short-description>` for documentation
3. Make focused changes with clear commit messages.

## Development guidelines

- Keep scripts POSIX/Bash-friendly and consistent with existing style.
- Prefer small, isolated changes over large mixed refactors.
- Update documentation (`README.md`, app `README.md`) when behavior changes.
- For new apps, include:
  - `install.sh`
  - `remove.sh`
  - launcher `.desktop`
  - app `README.md`

## Validation before opening a PR

Run at least:

```bash
bash -n install.bash common.bash
find apps -type f \( -name "*.sh" -o -name "*.bash" \) -print0 | xargs -0 -n1 bash -n
```

If available, also run:

```bash
shellcheck install.bash common.bash apps/*/*.sh
```

## Pull request checklist

- [ ] Branch is up to date with `main`
- [ ] Changes are scoped and documented
- [ ] Scripts pass syntax checks (`bash -n`)
- [ ] PR description explains what changed and why
- [ ] Include screenshots/logs for UI/behavior changes when useful

## Commit messages

Use clear imperative messages, for example:

- `Add Netflix launcher icon install/remove`
- `Fix optional app installer discovery path`
- `Update README supported applications list`

## Reporting issues

When opening an issue, include:

- Fedora version
- GNOME version
- What command was run
- Expected vs actual behavior
- Relevant logs/output
