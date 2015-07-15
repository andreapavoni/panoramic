module Panoramic
  module Orm
    module Mongoid
      extend ActiveSupport::Concern

      included do
        include ::Mongoid::Timestamps unless include? ::Mongoid::Timestamps

        field :body, type: String
        field :partial, type: Boolean, default: false
        field :path, type: String
        field :format, type: String
        field :locale, type: String
        field :handler, type: String

        validates :body,    :presence => true
        validates :path,    :presence => true
        validates :format,  :inclusion => Mime::SET.symbols.map(&:to_s)
        validates :locale,  :inclusion => I18n.available_locales.map(&:to_s), :allow_nil => true
        validates :handler, :inclusion => ActionView::Template::Handlers.extensions.map(&:to_s)

        after_save { Panoramic::Resolver.instance.clear_cache }
      end

      module ClassMethods
        def find_model_templates(conditions = {})
          conditions[:handler.in] = Array(conditions.delete(:handler))
          conditions[:locale.in]  = Array(conditions.delete(:locale))
          where(conditions)
        end

        def resolver(options={})
          Panoramic::Resolver.using self, options
        end
      end
    end
  end
end