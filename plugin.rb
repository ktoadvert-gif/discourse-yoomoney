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
  require_dependency "application_controller"
  class ::Yoomoney::YoomoneyController < ::ApplicationController
    requires_plugin Yoomoney::PLUGIN_NAME
    skip_before_action :verify_authenticity_token, only: [:notification]
    skip_before_action :check_xhr, only: [:notification]
    def notification
      # Validate SHA1 hash from YooMoney
      # notification_type&operation_id&amount&currency&datetime&sender&codepro&notification_secret&label
      
      params_to_hash = [
        params[:notification_type],
        params[:operation_id],
        params[:amount],
        params[:currency],
        params[:datetime],
        params[:sender],
        params[:codepro],
        SiteSetting.yoomoney_notification_secret,
        params[:label]
      ].join('&')
      calculated_sha1 = Digest::SHA1.hexdigest(params_to_hash)
      if calculated_sha1 == params[:sha1_hash]
        # Valid notification
        user_id = params[:label].to_i
        user = User.find_by(id: user_id)
        if user && params[:unwithdraw].to_s == 'false'
          group = Group.find_by(name: SiteSetting.yoomoney_target_group)
          if group
            group.add(user)
            Rails.logger.info "YooMoney: Added user #{user.username} (ID: #{user.id}) to group #{group.name}"
          else
            Rails.logger.error "YooMoney: Target group '#{SiteSetting.yoomoney_target_group}' not found"
          end
        end
        render plain: "OK", status: 200
      else
        Rails.logger.error "YooMoney: Invalid SHA1 hash. Expected #{calculated_sha1}, got #{params[:sha1_hash]}"
        render plain: "Invalid hash", status: 400
      end
    end
  end
  Yoomoney::Engine.routes.draw do
    post "/notification" => "yoomoney#notification"
  end
  Discourse::Application.routes.append do
    mount ::Yoomoney::Engine, at: "/yoomoney"
  end
end