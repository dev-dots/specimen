# specimen

Doing the same things over and over again in test automation was the initial inspiration of coming up with a gem which
will help me with:

- setting up a new test automation project, including README, Gemfile, rubocop.yml, etc...
- run Cucumber and RSpec tests with configs that make sense (e.g. parallel execution, reporting)
- provide a Rails like templating approach in terms of _convention over configuration_ to provide a maintainable base
  for
  API or UI tests using RSpec and/or Cucumber.

## How to start?

To get familiar with specimen, you can simply create initialize a new project by running the following command.

```shell
specimen init --name example-project
```

This will do the following things for you

- create a new directory `/example-project` relative to your current working directory
- create initial files for running Cucumber or RSpec tests as well as project root files such as a README.md, Gemfile,
  etc...
- creates a new encrypted configuration in `/example-project/config/enc/example.yml.enc`
- creates a new key file in `/example-project/config/enc/example.key` containing the key value to decrypt the
  configuration which is required when you need to update the encrypted config.
- creates a .env-file `/example-project/.example.env` containing the `MASTER_KEY` variable and the key value to decrypt
  the config

Now you can switch to the newly created directory `/example-project` and run e.g. the following commands

```shell
# install Rubygems first
bundle install

# run Cucumber tests without additional options
specimen cukes

# run Cucumber tests tagged with @pass
specimen cukes -t @pass

# run RSpec tests without additional options
specimen specs

# run RSpec tests tagged with pass: true
specimen specs -t pass

# run Cucumber|RSpec tests using the example specimen-profile
# The 'examples' profile will automatically load and decrypt the 
# encrypted configuration /config/enc/example.yml.enc during execution.
specimen cukes|specs --sp|--specimen-profile examples
```

## specimen commands

```shell
Usage:
  specimen COMMAND [options]

You must specify a command:

  init         Initialize a new specimen project
  cukes        Run Cucumber tests
  specs        Run RSpec tests
  enc          Create or update encrypted configurations

  -v|--version Show specimen version
  -h|--help    You are looking at it

All commands can be run with -h (or --help) for more information.
```

### specimen init

TBD

### specimen cukes

TBD

### specimen specs

TBD

### Known issues

- tests are missing
- tests do not run in parallel (yet)
- documentation about allowed options in config-yml´s
- templates for docker, Selenium, Watir and Playwright