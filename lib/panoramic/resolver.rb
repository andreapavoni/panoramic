module Panoramic
  class Resolver < ActionView::Resolver
    require "singleton"
    include Singleton

    # this method is mandatory to implement a Resolver
    def find_templates(name, prefix, partial, details, key=nil, locals=[])
      return [] if @@resolver_options[:only] && !@@resolver_options[:only].include?(prefix)

      path = build_path(name, prefix)
      conditions = {
        :path    => path,
        :locale  => [normalize_array(details[:locale]).first, nil],
        :format  => normalize_array(details[:formats]),
        :handler => normalize_array(details[:handlers]),
        :partial => partial || false
      }.merge(details[:additional_criteria].presence || {})

      @@model.find_model_templates(conditions).map do |record|
        Rails.logger.debug "Rendering template from database: #{path} (#{record.format})"
        initialize_template(record)
      end
    end

    # Instantiate Resolver by passing a model (decoupled from ORMs)
    def self.using(model, options={})
      @@model = model
      @@resolver_options = options
      self.instance
    end

    private

    # Initialize an ActionView::Template object based on the record found.
    def initialize_template(record)
      source = record.body
      identifier = "#{record.class} - #{record.id} - #{record.path.inspect}"
      handler = ActionView::Template.registered_template_handler(record.handler)

      ActionView::Template.new(source, identifier, handler,
                               :locals => [],
                               :format => Mime[record.format].to_sym,
                               :virtual_path => virtual_path(record.path, record.partial))
    end

    # Build path with eventual prefix
    def build_path(name, prefix)
      prefix.present? ? "#{prefix}/#{name}" : name
    end

    # Normalize array by converting all symbols to strings.
    def normalize_array(array)
      array.map(&:to_s)
    end

    # returns a path depending if its a partial or template
    def virtual_path(path, partial)
      return path unless partial
      if index = path.rindex("/")
        path.insert(index + 1, "_")
      else
        "_#{path}"
      end
    end
  end
end
