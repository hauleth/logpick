-module(logpick_h).

-export([set/3]).

-export([log/2]).

-define(key(K), {?MODULE, K}).

set(Modules, Level, Type) ->
    State = new(Type),
    logger:set_module_level(Modules, Level),
    [persistent_term:put(?key(Module), {State, Modules}) || Module <- Modules],
    ok.

log(#{meta := #{mfa := {Module, _, _}}}, _Config) ->
    case persistent_term:get(?key(Module), undefined) of
        undefined -> ok;
        {Type, Modules} ->
            case check(Type) of
                false ->
                    logger:unset_module_level(Modules),
                    [persistent_term:erase(?key(Mod)) || Mod <- Modules],
                    ok;
                true ->
                    ok
            end
    end;
log(_LogEvent, _Config) ->
    ok.

new({counter, Max}) ->
    {counter, counters:new(1, [atomics]), Max};
new({time, {Value, Unit}}) ->
    EndTime = erlang:monotonic_time()
        + erlang:convert_time_unit(Value, Unit, native),
    {time, EndTime}.

check({counter, C, Max}) ->
    counters:add(C, 1, 1),
    counters:get(C, 1) < Max;
check({time, EndTime}) ->
    erlang:monotonic_time() =< EndTime.
