-module(logpick).

-export([install/0,
         set_module_level/3]).

install() ->
    logger:add_handler(?MODULE, logpick_h, #{
                                  level => all,
                                  filter_default => log
                                 }).

set_module_level(Module, Level, Type) when is_atom(Module) ->
    set_module_level([Module], Level, Type),
    ok;

set_module_level(Modules, Level, Type) ->
    _ = install(),
    logpick_h:set(Modules, Level, Type).
