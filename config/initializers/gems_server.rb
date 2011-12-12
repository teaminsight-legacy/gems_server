repo_path = Pathname.new("/mnt/insight_repository/environments")
REPOSITORY_PATH = repo_path.join(Rails.env, "gems_server")

module GemsServer
  include NsOptions
  options :settings
end

GemsServer.settings do
  namespace :api_v0 do
    option :stored_at, Pathname, :default => REPOSITORY_PATH.join("api_v0")
  end
end