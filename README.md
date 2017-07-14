# TIL
[![Build Status](https://travis-ci.org/GustavoCaso/til.svg?branch=master)](https://travis-ci.org/GustavoCaso/til)

This project is the consequence of listening to one of my favorite Podcast [ElixirFountain](http://elixirfountain.com/) in particular an interview with Josh Branchaud were he mentioned his Today I Learned Repo.

This CLI whats to help you commit to the idea of storing small pieces of information that you learn throughout the day.
As a developer I love to spent time in my terminal. What about been able to keep updated with you TIL challenge without leaving the terminal.

### Usage

#### Login

To allow the application write on your github account you first have to login. In order for application to communicate with Github you will need to create a Personal Access Token.

`til --login`

Will start the login workflow to create it.

You can also create it by yourself following this guide [PersonalAccessToken](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/), after creating it you can save it by using

`til --auth-token TOKEN`

Both command will create a config file in your home directory, remember you can revoke the access by deleting the configuration file or the personal access token.

#### Creating TIL entries

`til WHAT EVER YOU HAVE LEARN`

Will create a new **public** gists with your information you have provided.

We can pass a number of arguments to customize you gist:

`til --description DESCRIPTION WHAT EVER YOU HAVE LEARN` custom description

`til --public  WHAT EVER YOU HAVE LEARN` to make the gists public, by default it is, to make it private please add the argument `--no-public`

`til --file-name FILENAME WHAT EVER YOU HAVE LEARN` to modify the filename of the gists.

You can use all this options together.

### ROADMAP

- [ ] Make the CLI available via `brew`
- [ ] Allow to upload gists via files
- [ ] Open a REPL to type all your TIL making it more interactive.
- [ ] Allow the possibility to create a repo instead of gists and manage from the Terminal. Allowing to have categories, automatic README update etc.. probably v2 :smile:
- [ ] Add Documentation via ExDoc

### CONTRIBUTING

All contributions are more than welcome.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/til](https://hexdocs.pm/til).
