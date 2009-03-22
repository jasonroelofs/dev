#!/usr/bin/ruby

# Takes a name on stdin, builds a gen_server template
# for that name

name = STDIN.read.strip

TEMPLATE =<<-END
-module(#{name}).

-behaviour(gen_server).

-export([init/1, 
    handle_call/3, 
    handle_cast/2, 
    handle_info/2, 
    terminate/2, 
    code_change/3]).

-export([start_link/0, shutdown/0]).

%% Client Functions %%
start_link() -> 
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

shutdown() ->
  gen_server:cast(?MODULE, stop).

%% Gen Server %%
init([]) -> 
  {ok, []}.


%% Calling
handle_call(_Request, _From, State) -> 
  {reply, ignored, State}.


%% Casting
handle_cast(stop, State) -> 
  {stop, normal, State};
handle_cast(_Msg, State) -> 
  {noreply, State}.


%% Info
handle_info(_Info, State) -> 
  {noreply, State}.


%% Terminate
terminate(_Reason, _State) -> 
  ok.


%% Code Change
code_change(_OldVsn, State, _Extra) -> 
   {ok, State}.


%% Private Methods %%
END

puts TEMPLATE
