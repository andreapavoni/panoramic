require 'spec_helper'

describe FooController, type: :controller do
  include Capybara::DSL
  render_views

  context "renders views fetched from database with" do
    it "a basic template" do
      FactoryBot.create(:database_template, :path => 'foo/default_layout')

      visit '/foo/default_layout'

      expect(response).to render_template("foo/default_layout" )
      expect(page.body).to match(/something here in the body of the page: 4/)
    end

    it "a custom layout" do
      FactoryBot.create(:database_template, :path => 'foo/custom_layout')
      FactoryBot.create(:database_template, :path => 'layouts/custom', :body => 'This is a layout with body: <%= yield %>')

      visit '/foo/custom_layout'

      expect(response).to render_template("layouts/custom" )
      expect(response).to render_template("foo/custom_layout" )
      expect(page.body).to match(/This is a layout with body:/)
      expect(page.body).to match(/something here in the body of the page:/)
    end
  end
end
