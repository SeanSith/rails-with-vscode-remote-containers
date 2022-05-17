#!/bin/bash

if [ -f Gemfile ] ; then
  bundle install
else
  rails new . --database=mysql --css=tailwind --force
fi
bin/dev
