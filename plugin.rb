# name: discourse-yoomoney
# about: Accept payments via YooMoney (ЮMoney) on Discourse
# version: 0.1
# authors: Antigravity
# url: https://github.com/discourse/discourse-yoomoney
enabled_site_setting :yoomoney_enabled
register_asset "stylesheets/yoomoney.scss"
after_initialize do
  module ::Yoomoney
    PLUGIN_NAME = "discourse-yoomoney"

    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace Yoomoney
    end
  end

  Yoomoney::Engine.routes.draw do
    post "/notification" => "yoomoney#notification"
  end

  Discourse::Application.routes.append do
    mount ::Yoomoney::Engine, at: "/yoomoney"
  end
end