# GHAS ESLint Action

Runs eslint and uploads the results to GitHub Advanced security.  ESLint will use the options specified in the `.eslintrc.json`.  If you are using any additional ESLint plugins you will have to ensure they are installed as part of the Action workflow prior to the ESLint action.

## Inputs

### `src-dir`

OPTIONAL: The directory to scan with ESLint.  Will default to the root directory of the repository if not specified.

### `eslint-opts`

OPTIONAL: Any additional options to pass to the eslint command line.

### `github-token`

OPTIONAL: The token that will be used to upload the security results.  Will default to the Action workflow's GITHUB_TOKEN.


## Example usage

    - name: GHAS ESLint Action
      uses: thedave42/ghas-eslint-action@main
     
