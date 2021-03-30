# Composer Diff action

This action compares your `composer.lock` files and generates human-readable report with packages changed in PR or commit using [composer-diff](https://github.com/IonBazan/composer-diff).
You may use the action output to annotate your code or add a comment to your Pull Request.

## Example

Here's an example of the Composer Diff Github Action providing feedback on a Pull Request:

![preview](preview.png)

_**Note:** you must use the actions/checkout step with `fetch-depth: 0` as shown below before running the Composer Diff action in order for it to function properly_
_You may set it to `1` if you want to compare only with the previous commit._

```yaml
name: Composer Diff
on: [pull_request]
jobs:
  composer-diff:
    name: Composer Diff
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0 # Required to make it possible to compare with PR base branch

      - name: Generate composer diff
        id: composer_diff # To reference the output in comment
        uses: IonBazan/composer-diff-action@v1

      - uses: marocchino/sticky-pull-request-comment@v2
        with:
          header: composer-diff # Creates a collapsed comment with the report
          message: |
            <details>
            <summary>Composer package changes</summary>

            ${{ steps.composer_diff.outputs.composer_diff }}

            </details>
```

## Inputs

This action takes same input arguments as the [composer-diff command](https://github.com/IonBazan/composer-diff#usage):

- `base` - base (old) `composer.lock` path and/or git reference - default: `${{ github.event.pull_request.base.sha }}` (last commit in base branch of PR)

  To use it with custom `composer.lock` path, follow `commit_hash:path/to/composer.lock` convention.
- `target` - target (new) `composer.lock` path and/or git reference - default: `composer.lock` (current file version)

  Follows same convention as `base` argument
- `format` - output format - either `mdtable`, `mdlist` or `json` - see [composer-diff documentation](https://github.com/IonBazan/composer-diff#usage) - default: `mdtable`
- `no-dev` - excludes dev dependencies - default: `false`
- `no-prod` - excludes prod dependencies - default: `false`
- `with-platform` - include platform (`php`, `ext-*`) dependencies - default: `false`
- `with-links` - adds compare/release URLs - default: `false`
- `extra-arguments` - additional arguments to be passed to the command - default: `--ansi` (for colorful output)

## Outputs

This command produces an output named `composer_diff` containing the output of the command with stripped colors and prepared for processing further with other actions (creating a comment, annotation, etc.).

You may reference it using:
```yaml
steps:
  - name: Generate composer diff
    id: composer_diff
    uses: IonBazan/composer-diff-action@v1
  - uses: foo/bar@v1
    with:
      diff: ${{ steps.composer_diff.outputs.composer_diff }}
```

