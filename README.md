# skm -- Ssh Key Manager

Skm is a tool to manage your multiple ssh keys.

[RubyGems][] | [![Build Status](https://secure.travis-ci.org/xuhdev/skm.png?branch=master)](http://travis-ci.org/xuhdev/skm)

## Installation

    gem install skm

## Usage

Create a new key:

    skm create my_new_key

Create a new key with comment:

    skm create my_new_key -C "my@email.com"

Switch to another key:

    skm use key_name

List all keys:

    skm list


For example, first we create two keys:

    skm create key1
    skm create key2

Then we switch to `key1`:

    skm use key1

After done some work, we could then switch to `key2`:

    skm use key2

Use `skm --help` and `skm [command] --help` to read more.

## Where are my keys?

By default, all your keys are put in `~/.skm`. But you can use other
directories by using `--skm-dir` option on command line.


[RubyGems]: https://rubygems.org/gems/skm
