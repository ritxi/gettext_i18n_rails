require 'gettext_i18n_rails/version'


# translate activerecord errors
if defined? Rails::Railtie # Rails 3+
  # load active_model extensions at the correct point in time
  require 'gettext_i18n_rails/railtie'
else

end

# # make bundle console work in a rails project
# require 'gettext_i18n_rails/action_controller' if defined?(ActionController)
