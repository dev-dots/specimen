# specimen

Doing the same things over and over again in test automation was the initial inspiration of coming up with a gem which
will help me with:

- setting up a new test automation project, including README, Gemfile, rubocop.yml, etc...
- run Cucumber and RSpec tests with configs that make sense (e.g. parallel execution, reporting)
- provide a Rails like templating approach in terms of _convention over configuration_ to provide a maintainable base for
  API or UI tests using RSpec and/or Cucumber.

## specimen commands

```shell
❯ specimen
Usage:
  specimen COMMAND [options]

You must specify a command:

  init         Initialize a new specimen project
  cukes        Run Cucumber tests (WIP)
  specs        Run RSpec tests (WIP)
  exec         Run tests via a config file (WIP)

All commands can be run with -h (or --help) for more information.
```

### specimen init

```shell
❯ specimen init -h
Usage:
  specimen init --name=NAME [options]   # Create a new specimen project which will generate following dirs and files

                                          * default directories /config, /lib, /tmp
                                          * default directories (/features/..) and files for cucumber unless --skip-cucumber
                                          * default directories (/spec/..) and files for RSpec unless --skip-rspec
                                          * root path files:
                                            * .gemrc
                                            * .gitignore
                                            * .rspec (unless --skip-rspec)
                                            * .rubocop.yml
                                            * cucumber.yml (unless --skip-cucumber)
                                            * Gemfile (based on the used options)
                                            * README.md
                                            * specimen.yml (default configuration file for the specimen gem

Options:
  -n, [--name=NAME]                     # required: true
                                          The name of your project and installation path relative to your current PWD

      [--ui-driver=UI_DRIVER]           # Default: 'watir'
                                          Valid options are:
                                            * watir
                                            * selenium
                                            * selenium-webdriver

      [--skip-ui]                       # Default: false
                                          Don´t add selenium or watir gem to your Gemfile

      [--skip-cucumber]                 # Default: false
                                          No cucumber gems will be added to your Gemfile.
                                          Creation of cucumber directories and files will be skipped.

      [--skip-rspec]                    # Default: false
                                          RSpec will still be in your Gemfile (as it´s matchers are used for cucumber)
                                          but no RSpec directories and files will be generated
```

### specimen cukes

TBD

### specimen specs

TBD

### specimen exec

TBD

### Known issues

- tests are missing