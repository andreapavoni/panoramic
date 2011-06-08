class FooController < ApplicationController
  prepend_view_path DatabaseTemplate.resolver

  layout 'custom', :only => :custom_layout

  def default_layout
  end

  def custom_layout
  end
end

