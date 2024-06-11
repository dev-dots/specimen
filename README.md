# specimen

Doing the same things over and over again in test automation was the initial inspiration of coming up with a gem which
will help me with:

- setting up a new test automation project, including README, Gemfile, rubocop.yml, etc...
- run Cucumber and RSpec tests with configs that make sense (e.g. parallel execution, reporting)
- provide a Rails like templating approach in terms of _convention over configuration_ to provide a maintainable base for
  API or UI tests using RSpec and/or Cucumber.


**Beware**

At the point of writing the README and setting the repo to public, the gem does not do much yet so the current functionality
is minimal, not optimized and not tested :). Hopefully that will change in the future.

```shell
# install Specimen gem
$> gem install specimen

# creates a new project relative to the current working directory. Will ask for a project name.
$> specimen init

# creates a new project 'foobar' relative to the current working directory.
# Inside /foobar you will find the default dir structures for Cucumber and RSpec tests and a few more files
$> specimen init -n foobar

# look at the command help
$> specimen help init
Usage:
  specimen init

Options:
  --name, -n, [--project-name=PROJECT_NAME]
              [--api-only], [--no-api-only], [--skip-api-only]  # Default: false  
              [--cucumber], [--no-cucumber], [--skip-cucumber]  # Default: true
```


### Known issues

- tests are missing
- generated Gemfile contains Watir and Selenium webdriver, it should be only one of them.