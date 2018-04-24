# innoq-blockchain-ruby

This is a demo blockchain app developed (mostly) during a two day retreat
at our company, [INNOQ](https://www.innoq.com/en/). 

Several teams worked on 
[similar apps](https://github.com/search?p=2&q=innoq%2Finnoq-blockchain&type=Repositories)
based on the same requirements sketch.
All of these apps use (more or less) different technology stacks, which most
of the participants in each team had never used before.

Also, hardly any of us had an idea how blockchains _really_ work, beyond 
the Bitcoin hype. Therefore we had a twofold learning experience: 
the technology stack and the blockchain concept.

## Install & Run

This app is a run of the mill Ruby on Rails 5.1 web application.

In order to try it, you need to

* Have ruby 2.4 installed

* Install `bundler`

```bash
$ gem install bundler
```

* Clone the git repositry

```bash
$ git clone git@github.com:innoq/innoq-blockchain-ruby.git
```

* Install the required dependencies

```bash
$ cd innoq-blockchain-ruby
```

```bash
$ bundle install
```

or only locally

```bash
$ bundle install --path vendor/bundle
```

* Initialize the database

```bash
$ rails db:setup
```

* Start the app

```bash
$ rails server
```

* Open your browser at [http://localhost:3000](http://localhost:3000)
