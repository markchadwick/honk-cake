# Honk!  Cake!

![Honk!  Cake!](http://i.imgur.com/WrhpNfC.jpg)

### Usage

In your Cakefile, adding a:

```coffeescript
require('honk-cake').all()
```

will get you common tasks for running Mocha tests, using Docco to generate
documentation, and pushing that documentation to Github Pages.  It uses
executables in your node_modules directory to run these tasks.

For instance, a `cake test` will run: 

`./node_modules/.bin/mocha --compilers coffee:coffee-script --colors --recursive -R spec .` 

A `cake -f test/models test` will run tests only for your models.

A `cake -f test/models test:watch` will run tests only for your models when your
tests are modified.

