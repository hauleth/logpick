# logpick

An utility for temporarly changing verbosity level for Erlang modules.

## Usage

Logpick allows  you to temporarily increase the verbosity level for given
modules. The "temporarily" part is useful when you do it in the production and
you do not want to overload log service by forgetting to reset verbosityafter
work is done.

Logpick API is quite simple, just call `logpick:set_module_level/3` with module
name, requested level and specification of when to reset verbosity to it's
original value:

```erlang
logpick:set_module_level(foo, debug, {counter, 1}).
```

Supported types are:

- `{counter, N}` which will allow at most `N` events to be logged
- `{time, {N, Unit}}` which will reset verbosity after `N` units of time (`Unit`
  is atom as specified by `erlang:time_unit/0`)
