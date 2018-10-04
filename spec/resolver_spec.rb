require 'spec_helper'

describe Panoramic::Resolver do
  let(:resolver) { Panoramic::Resolver.using(DatabaseTemplate) }

  context ".find_templates" do
    it "should lookup templates for given params" do
      template = FactoryBot.create(:database_template, :path => 'foo/example')
      details = { :formats => [:html], :locale => [:en], :handlers => [:erb] }
      expect(resolver.find_templates('example', 'foo', false, details).first).to_not be_nil
    end

    it "should lookup locale agnostic templates for given params" do
      template = FactoryBot.create(:database_template, :path => 'foo/example', :locale => nil)
      details = { :formats => [:html], :locale => [:en], :handlers => [:erb] }
      expect(resolver.find_templates('example', 'foo', false, details).first).to_not be_nil
    end

    it "should lookup templates for given params and prefixes" do
      resolver = Panoramic::Resolver.using(DatabaseTemplate, :only => 'foo')
      details = { :formats => [:html], :locale => [:en], :handlers => [:erb] }

      template = FactoryBot.create(:database_template, :path => 'bar/example')
      expect(resolver.find_templates('example', 'bar', false, details).first).to be_nil

      template = FactoryBot.create(:database_template, :path => 'foo/example')
      expect(resolver.find_templates('example', 'foo', false, details).first).to_not be_nil
    end

    it "should lookup multiple templates" do
      resolver = Panoramic::Resolver.using(DatabaseTemplate, :only => 'foo')
      details = { :formats => [:html,:text], :locale => [:en], :handlers => [:erb] }
      details[:formats].each do |format|
        FactoryBot.create(:database_template, :path => 'foo/example', :format => format.to_s)
      end
      templates = resolver.find_templates('example', 'foo', false, details)
      expect(templates.length).to be >= 2
      expect(templates.map(&:formats).flatten.uniq).to eq([:html, :text])
    end
  end
end

describe_private Panoramic::Resolver, '(private methods)' do
  let(:resolver) { Panoramic::Resolver.using(DatabaseTemplate) }

  context "#build_path" do
    it "returns prefix/name if prefix is passed" do
      expect(resolver.build_path('path', 'prefix')).to eq('prefix/path')
    end

    it "returns name if prefix is nil" do
      expect(resolver.build_path('path',nil)).to eq('path')
    end
  end

  context "#normalize_array" do
    it "converts all symbols to strings" do
      expect(resolver.normalize_array([:something, 'that', :matters])).to eq(['something','that','matters'])
    end
  end

  context "#initialize_template" do
    let(:template) { FactoryBot.create :database_template }

    it "initializes an ActionView::Template object" do
      expect(resolver.initialize_template(template)).to be_a(ActionView::Template)
    end
  end

  context "#virtual_path" do
    it "returns 'path' if is not a partial" do
      expect(resolver.virtual_path('path',false)).to eq('path')
    end

    it "returns '_path' if is a partial" do
      expect(resolver.virtual_path('path',true)).to eq('_path')
    end
  end

end
