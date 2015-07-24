module GettextI18nRails
  class Railtie < ::Rails::Railtie
    config.gettext_i18n_rails = ActiveSupport::OrderedOptions.new
    config.gettext_i18n_rails.msgmerge = nil
    config.gettext_i18n_rails.xgettext = nil
    config.gettext_i18n_rails.use_for_active_record_attributes = true

    rake_tasks do
      begin
        gem "gettext", ">= 3.0.2"
        require 'gettext_i18n_rails/tasks'
      rescue Gem::LoadError
        # no gettext available, no tasks for you!
      end
    end

    config.after_initialize do |app|
      if defined?(ActiveModel) && !defined?(ActiveRecord)
        require 'gettext_i18n_rails/active_model'
      end

      if app.config.gettext_i18n_rails.use_for_active_record_attributes
        ActiveSupport.on_load :active_record do
          require 'gettext_i18n_rails/active_record'
        end
      end

      require 'gettext_i18n_rails/gettext_hooks'

      module ::GettextI18nRails
        IGNORE_TABLES = [/^sitemap_/, /_versions$/, 'schema_migrations', 'sessions', 'delayed_jobs']
      end

      Object.send(:include, FastGettext::Translation)

      # make translations html_safe if possible and wanted
      if "".respond_to?(:html_safe?)
        require 'gettext_i18n_rails/html_safe_translations'
        Object.send(:include, GettextI18nRails::HtmlSafeTranslations)
      end

      # set up the backend
      require 'gettext_i18n_rails/backend'
      I18n.backend = GettextI18nRails::Backend.new

      # make I18n play nice with FastGettext
      require 'gettext_i18n_rails/i18n_hacks'

      return unless defined?(ActionController)
      # make bundle console work in a rails project
      require 'gettext_i18n_rails/action_controller'
    end
  end
end
