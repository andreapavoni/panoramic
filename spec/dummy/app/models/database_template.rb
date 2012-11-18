if defined? ActiveRecord
  class DatabaseTemplate < ActiveRecord::Base
    # include DatabaseTemplates::Orm::ActiveRecord
    store_templates
  end
end

if defined? Mongoid
  class DatabaseTemplate
    include Mongoid::Document
    include Panoramic::Orm::Mongoid
  end
end
