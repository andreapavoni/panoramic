require 'spec_helper'

describe Panoramic::Resolver do
  let(:resolver) { Panoramic::Resolver.using(DatabaseTemplate) }

  context ".find_templates" do
    it "should lookup templates for given params" do
      template = FactoryGirl.create(:database_template, :path => 'foo/example')
      details = { :formats => [:html], :locale => [:en], :handlers => [:erb] }
      resolver.find_templates('example', 'foo', false, details).first.should_not be_nil
    end

    it "should lookup locale agnostic templates for given params" do
      template = FactoryGirl.create(:database_template, :path => 'foo/example', locale: nil)
      details = { :formats => [:html], :locale => [:en], :handlers => [:erb] }
      resolver.find_templates('example', 'foo', false, details).first.should_not be_nil
    end

    it "should lookup templates for given params and prefixes" do
      resolver = Panoramic::Resolver.using(DatabaseTemplate, :only => 'foo')
      details = { :formats => [:html], :locale => [:en], :handlers => [:erb] }

      template = FactoryGirl.create(:database_template, :path => 'bar/example')
      resolver.find_templates('example', 'bar', false, details).first.should be_nil

      template = FactoryGirl.create(:database_template, :path => 'foo/example')
      resolver.find_templates('example', 'foo', false, details).first.should_not be_nil
    end
  end
end

describe_private Panoramic::Resolver, '(private methods)' do
  let(:resolver) { Panoramic::Resolver.using(DatabaseTemplate) }

  context "#build_path" do
    it "returns prefix/name if prefix is passed" do
      resolver.build_path('path', 'prefix').should == 'prefix/path'
    end

    it "returns name if prefix is nil" do
      resolver.build_path('path',nil).should == 'path'
    end
  end

  context "#normalize_array" do
    it "converts all symbols to strings" do
      resolver.normalize_array([:something, 'that', :matters]).should == ['something','that','matters']
    end
  end

  context "#initialize_template" do
    let(:template) { FactoryGirl.create :database_template }

    it "initializes an ActionView::Template object" do
      resolver.initialize_template(template).should be_a(ActionView::Template)
    end
  end

  context "#virtual_path" do
    it "returns 'path' if is not a partial" do
      resolver.virtual_path('path',false).should == 'path'
    end

    it "returns '_path' if is a partial" do
      resolver.virtual_path('path',true).should == '_path'
    end
  end

end
