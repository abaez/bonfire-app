defmodule Bonfire.Application do

  @sup_name Bonfire.Supervisor
  @name Mix.Project.config()[:name]
  @otp_app Bonfire.Common.Config.get!(:otp_app)
  @env Application.compile_env!(@otp_app, :env)
  @version Mix.Project.config()[:version]
  @repository Mix.Project.config()[:source_url]
  @deps Bonfire.Common.Extend.loaded_deps()
  @endpoint_module Application.compile_env!(@otp_app, :endpoint_module)
  @repo_module Application.compile_env!(@otp_app, :repo_module)

  use Application
  require Cachex.Spec

  def start(_type, _args) do

    EctoSparkles.Log.setup(@repo_module)
    # Ecto.DevLogger.install(@repo_module)

    Bonfire.ObanLogger.setup()
    Oban.Telemetry.attach_default_logger()

    applications(@env, Bonfire.Common.Extend.module_enabled?(Bonfire.API.GraphQL) and Bonfire.Common.Extend.module_enabled?(Bonfire.API.GraphQL.Schema)) #|> IO.inspect
    |> Supervisor.start_link(strategy: :one_for_one, name: @sup_name)
  end

  def applications(env, true = _with_graphql?) do # include GraphQL API
    [
      {Absinthe.Schema, Bonfire.API.GraphQL.Schema} # use persistent_term backend for Absinthe
    ]
    ++ applications(env, :default)
    ++
    [
      {Absinthe.Subscription, @endpoint_module}
    ]
  end

  @apps_before [
    Bonfire.Web.Telemetry,                  # Metrics
    @repo_module,                           # Database
    EctoSparkles.AutoMigrator,
    # Bonfire.Common.ConfigModules,
    # Bonfire.Common.Config.LoadExtensionsConfig,
    Bonfire.Me.Settings.LoadInstanceConfig, # load instance Settings from DB into Config
    {Phoenix.PubSub, [name: Bonfire.PubSub, adapter: Phoenix.PubSub.PG2]}, # PubSub
    # Persistent Data Services
    Pointers.Tables,
    # Bonfire.Data.AccessControl.Accesses,
    Bonfire.Common.ContextModules,
    Bonfire.Common.QueryModules,
    Bonfire.Federate.ActivityPub.FederationModules
  ]

  @default_cache_ttl 1_000 * 60 * 60 * 6 # 6 hours

  # Stuff that depends on all the above
  @apps_after [
      @endpoint_module, # Web app
      {Oban, Application.fetch_env!(:bonfire, Oban)}, # Job Queue
      %{
        id: :bonfire_cache,
        start: {Cachex, :start_link, [
          :bonfire_cache, [
            expiration: Cachex.Spec.expiration(
              default: @default_cache_ttl,
              interval: 1000
            ),
            limit: 5000 # increase for instances with more users (at least num. of users*2+1)
      ]]}}
    ]

  def applications(:test, _any) do
    @apps_before
    # ++ [Bonfire.Web.FakeRemoteEndpoint]
    ++ @apps_after
  end

  def applications(_env, _any) do # default apps
    @apps_before ++ @apps_after
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    @endpoint_module.config_change(changed, removed)
    :ok
  end

  def name(), do: Application.get_env(:bonfire, :app_name, @name)
  def version, do: @version
  def named_version, do: name() <> " " <> @version
  def repository, do: @repository
  def deps, do: @deps

end
