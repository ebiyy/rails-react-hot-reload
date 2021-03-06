require "rack/proxy"

class AssetsPathProxy < Rack::Proxy
  def perform_request(env)
    if env["PATH_INFO"].include?("/javascripts/")
      set_env_for_path_info(env, "javascripts")
      super
    elsif env["PATH_INFO"].include?("/images/")
      set_env_for_path_info(env, "images")
      super
    else
      @app.call(env)
    end
  end

  private

  def set_env_for_path_info(env, asset_type)
    if Rails.env != "production"
      dev_server = env["HTTP_HOST"].gsub(":3000", ":3035")
      env["HTTP_HOST"] = dev_server
      env["HTTP_X_FORWARDED_HOST"] = dev_server
      env["HTTP_X_FORWARDED_SERVER"] = dev_server
    end
    env["PATH_INFO"] = "/assets/#{asset_type}/" + env["PATH_INFO"].split("/").last
  end
end