{spawn, exec} = require 'child_process'

_         = require 'lodash'
deferred  = require 'deferred'


# Full-resolve a binary installed by [npm](https://npmjs.org). As noted
# elsewhere, because the returned paths is absolute, even if a fully-resolvable
# alternative is available in the $PATH, this will cause the exec call to fail.
nodeBinary = (name) ->
  "./node_modules/.bin/#{name}"


# Adds manditory parameters to an existing environment. If no (or an empty)
# environment is given, this will use the current process' environment.
expandedEnv = (existing) ->
  env      = (existing or _.clone(process.env) or {})
  nodePath = env['NODE_PATH']?.split(':') or []

  _.extend env,
    NODE_PATH: ['./lib'].concat(nodePath).join(':')


# Run a binary command from the path. The stdout and stderr of the forked
# process will be "redirected" to the current process.
bin = (cmd, args, opts) ->
  defaults =
    echo:   true

  opts  = _.extend(defaults, opts)
  def   = deferred()
  proc  = spawn cmd, args, expandedEnv()

  if opts.echo
    proc.stdout.pipe(process.stdout)
    proc.stderr.pipe(process.stderr)
    proc.on 'exit', (status) -> def.resolve(status: status)

  else
    stdout = ''
    stderr = ''
    proc.stdout.on 'data', (s) -> stdout += s
    proc.stderr.on 'data', (s) -> stderr += s
    proc.on 'exit', (status) ->
      def.resolve
        status: status
        stdout: stdout
        stderr: stderr

  return def.promise


# Launch a binary installed by [npm](https://npmjs.org/). This will assume the
# binary is available in `./node_modules/.bin/` and will flat-out fail if the
# binary is available elsewhere. The semantics of the function are the same as
# `bin`.
node = (cmd, args, opts) ->
  bin(nodeBinary(cmd), args, opts)


module.exports =
  nodeBinary:   nodeBinary
  expandedEnv:  expandedEnv
  bin:          bin
  node:         node
