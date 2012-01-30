require 'spec_helper'

describe FooController do
  include Capybara::DSL
  render_views

  context "renders views fetched from database with" do
    it "a basic template" do
      Factory.create(:database_template, :path => 'foo/default_layout')

      visit '/foo/default_layout'

      response.should render_template("foo/default_layout" )
      page.body.should match(/something here in the body of the page: 4/)
    end

    it "a custom layout" do
      Factory.create(:database_template, :path => 'foo/custom_layout')
      Factory.create(:database_template, :path => 'layouts/custom', :body => 'This is a layout with body: <%= yield %>')

      visit '/foo/custom_layout'

      response.should render_template("layouts/custom" )
      response.should render_template("foo/custom_layout" )
      page.body.should match(/This is a layout with body:/)
      page.body.should match(/something here in the body of the page:/)
    end
  end
end
