# AGENTS.md

Guidance for AI coding agents working in this repository.

This is a Docker-based GitHub Action that runs the
[composer-diff](https://github.com/IonBazan/composer-diff) Composer plugin. Behaviour of the diff itself lives in
that repository; this one only maps action inputs to command options.

## Layout

- `action.yml` - action inputs, outputs and the arguments passed to the container.
- `entrypoint.sh` - drops empty arguments, expands the multi-line `filter` input, runs `composer diff` and writes the
  `composer_diff` and `composer_diff_exit_code` outputs.
- `Dockerfile` - installs composer-diff globally from Packagist, using the version constraint in `composer global require`.
- `README.md` - user documentation for every input and output.

## Adding or changing an input

When composer-diff gains or changes a command option, keep these in sync in the same change:

1. Add the input to `inputs` in `action.yml`, with a short description and `required: false` unless it must be set.
2. Pass it in `runs.args`, following the existing pattern
   (`${{ inputs.<name> && '--<name>' || '' }}` for flags, `format('--<name>={0}', ...)` for values).
   Empty strings are dropped by `entrypoint.sh`.
3. Document it in the `Inputs` section of `README.md`, linking to the composer-diff docs when the option needs more
   explanation.
4. Make sure the composer-diff version installed by the `Dockerfile` supports the option. A new option only works once
   it is released in a version matching that constraint.

## Checks

There is no test suite. Before committing, check that `action.yml` is valid YAML and that `entrypoint.sh` still passes
`bash -n`. To try the action end to end, build the image and run it inside a git checkout of a PHP project.
