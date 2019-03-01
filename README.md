[![Gem Version](https://badge.fury.io/rb/dru.svg)](https://badge.fury.io/rb/dru)

# Dru

DRU is a run utility to work on your projects with docker-compose where you can't put your config files inside the folder and also enhance the docker-compose command with custom commands, custom aliases, and environments support.

## Why should you use DRU?

Sometimes when we are working on projects, we can't put docker related configuration files into the project folder
or push it into our version control system.

Sure, we can always put the docker configuration files in a different place, but every time we have to run a command, it looks like:

    $ docker-compose -f ~/config_folder/docker-compose.yml up

and if we have another docker configuration for a different environment the things go even worst:

    $ docker-compose -f ~/config_folder/docker-compose.yml -f ~/config_folder/docker-compose.test.yml up

By following some simple conventions, DRU let we run the first command with:

    $ dru up

and the second will be like:

    $ dru -e test up

Furthermore, if we need to access the docker container shell, with vanilla docker-compose:

    $ docker-compose -f ~/config_folder/docker-compose.yml run --rm --entrypoint sh container_name

with DRU:

    $ dru shell container_name

## Installation

    $ gem install dru

## Usage

Run:

    $ dru help

for the list of the available commands.

All commands follow the same conventions. When you run a DRU command, by default it will look for a `docker-compose.yml` file into the `~/.dru/project_folder` where `project_folder` has the same name as the current working directory.

Suppose that you are in a directory called `example_project`, when you run a DRU command (e.g. `dru up`) it will search for a `docker-compose.yml` file into the `~/.dru/example_project` folder.

DRU also supports environments, that means that if you add the `-e test` option, it will combine the `~/.dru/example_project/docker-compose.yml` and `~/.dru/example_project/docker-compose.test.yml` into a single configuration.

Essentially it will run `docker-compose -f ~/.dru/example_project/docker-compose.yml -f ~/.dru/example_project/docker-compose.test.yml` when the second file name is given by the environment option. See [docker-compose documentation](https://docs.docker.com/compose/reference/overview/#specifying-multiple-compose-files) for more informations.

## Configuration

To override the default configuration you have to create the file `.druconfig` under your home folder:

```yaml
# ~/.druconfig

# default: ~/.dru if you like, you can set a custom location (path) for your docker configurations projects like ~/docker-config
docker_projects_folder: ~/.dru

# optional: use this if you want to create custom aliases
alias:
  shell: run --rm --entrypoint sh
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nebulab/dru. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

DRU is copyright © 2019 [Nebulab](http://nebulab.it/). It is free software, and may be redistributed under the terms specified in the [license](LICENSE.txt).

## About

![Nebulab](http://nebulab.it/assets/images/public/logo.svg)

DRU is funded and maintained by the [Nebulab](http://nebulab.it/) team.

We firmly believe in the power of open-source. [Contact us](http://nebulab.it/contact-us/) if you like our work and you need help with your project design or development.
