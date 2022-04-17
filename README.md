# README

Using Visual Studio Code's [Remote Containers](https://code.visualstudio.com/docs/remote/remote-overview) features, this
repository is an example of how to utilize the VSCode functionality to run a complete development environment using
containers. Please note that other than having VSCode, the VSCode "Remote Development" plugin, and Docker (tested on
Docker Desktop for macOS) installed, there are no other local dependencies.

## Prerequisites

1. Install [Visual Studio Code](https://code.visualstudio.com/).

2. Install the [Remote Development plugin](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack).

3. Install Docker Desktop:
  - [Windows](https://docs.docker.com/desktop/windows/install/)
  - [macOS](https://docs.docker.com/desktop/mac/install/)
  - Linux:
    - We'll assume if you're running Linux, you should know what you're doing

## Things to Know

- This repo orchestrates a docker-compose setup, so you should likely test the docker-compose setup if you're not using
  macOS.
- It will install Rails for you if it's not already there, but you will need to configure a couple of things to make it
  work and restart the stack.
- If you're not bringing your own Rails install, you'll get Ruby 3.x and Ruby on Rails with MySQL/MariaDB and
  TailwindCSS (via `tailwindcss-rails`). You're welcome to configure the stack however you like in `startup.sh`.
- I've also brought a few of my preferred VSCode extensions (see `devcontainer.json`). Feel free to add/subtract as
  necessary.

## Important URLs

- http://localhost:3000 - Normal Rails Server
- http://localhost:3001 - Debug Rails Server (if enabled via VSCode Run and Debug, see [Using Debugging](#using-debugging))

## First Time Starting the Stack

1. Clone this repository and open the directory in VSCode

1. When prompted or via the Command Pallette, "Reopen" the folder "in Containers"

At this point, the Docker setup will commence. It will download the necessary images from Docker Hub, build the
application container image, and copy the necessary VSCode pieces into place within the running application container.

It will also install Rails if you've not copied this repo into your existing Rails install, start up the
application stack (app container and MySQL container). Note that you should make the following manual changes:

1. Edit `config/database.yml` and change the database hostname to `database`.

1. Edit `Procfile.dev` (we're assuming Rails 7 here) to add `-b 0.0.0.0` to the `rails server` line. Otherwise Puma
   won't listen on the necessary network interface for your browser to access it.

Once all of that is done, the developer will be left with a VSCode window in which to develop, and the VSCode Terminal
will be running within the application container. From there, a developer should be able to do all of their normal work,
including bundling new gems, running migrations and rake tasks, etc. without having to worry about interacting directly
with Docker.

Once work is done, shutting down the stack is as simple as closing the folder window in VSCode.

## Using Debugging

After much trial and error, I could not find a good way to reliably start the Rails server with the
[`debug`](https://github.com/ruby/debug) gem that ships in Ruby 3.x (compatible back to Ruby 2.6). It would start fine,
but Puma times out after a while, and I was left with a less than stellar user experience. Therefore, my solution became
that I would package a `settings.json` for the VSCode debugger based on
[VSCode rdbg Ruby Debugger](https://marketplace.visualstudio.com/items?itemName=KoichiSasada.vscode-rdbg) that starts a
second Rails server at port 3001. If you want to use the Ruby `debug` gem, you can go into the VSCode Run and Debug
screen and start it from there. You will then need to switch your browser to port 3001 to use the new Rails server.

You can stop the debug server using the VSCode Run and Debug toolbar that appears.

## Benefits

- No need to install local tooling past having enough to run the VSCode editor and Docker.
- No locally running database servers.
- No language version managers: the containers set all necessary language versions, and Bundler behaves as expected.
- No complicated stack spin up with multiple commands and windows.

## Caveats

- The choice was made to remove NodeJS from this stack based on the decision in Rails 7 to focus on Import Maps and less
  built-in JavaScript through Stimulus and Turbo. I know old habits die hard, but this is only a reference repository.
  Should you require assistance in this fashion, please open an Issue and I'll reconsider the decision.
