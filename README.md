# GHAS ESLint Action

Runs eslint and uploads the results to GitHub Advanced security.  ESLint will use the options specified in the `.eslintrc.json` in the `src-dir`.  If you are using any additional ESLint plugins you will have to ensure they are installed in the `src-dir` as part of the Action workflow prior to the ESLint action.

## Inputs

### `src-dir`

OPTIONAL: The directory to scan with ESLint.  Will default to the root directory of the repository if not specified.

### `sarif-category`

OPTIONAL: Used to distinguish between multiple analyses performed on different parts of the code. e.g. different apps in a monorepo

### `eslint-opts`

OPTIONAL: Any additional options to pass to the eslint command line.

### `github-token`

OPTIONAL: The token that will be used to upload the security results.  Will default to the Action workflow's GITHUB_TOKEN.


## Example usage

    - name: GHAS ESLint Action
      uses: thedave42/ghas-eslint-action@main
     
## Example workflow

The will run ESLint against a single application in the root of the repository. 

    name: Lint application

    on:
      push:
        branches: [ main ]
      pull_request:
        # The branches below must be a subset of the branches above
        branches: [ main ]
      schedule:
        - cron: "20 5 * * 5"

    jobs:
      eslint-sarif-test:
        name: ESLint SARIF Test
        runs-on: ubuntu-latest

        strategy:
          matrix:
            node-version: ['14']

        steps:
          - name: 'Checkout code'
            uses: actions/checkout@v2

          - name: Use Node.js ${{ matrix.node-version }}
            uses: actions/setup-node@v1
            with:
              node-version: ${{ matrix.node-version }}

          - name: Build app
            run: |
              npm i
              
          - name: GHAS ESLint Action
            uses: thedave42/ghas-eslint-action@main
