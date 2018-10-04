require 'spec_helper'

describe Panoramic::Orm::ActiveRecord, type: :model do
  let(:template) { FactoryBot.build :database_template }

  context "validations" do
    it "has body present" do
      template.body = nil
      expect(template).to_not be_valid
      expect(template.errors[:body].size).to eq(1)
    end

    context "MIME format" do
      it "is valid" do
        template.format = 'notknown'
        expect(template).to_not be_valid
        expect(template.errors[:format].size).to eq(1)
      end

      it "is present" do
        template.format = nil
        expect(template).to_not be_valid
        expect(template.errors[:format].size).to eq(1)
      end
    end

    context "locale" do
      it "is valid even if not present" do
        template.locale = nil
        expect(template).to be_valid
      end
    end
  end

  context "handler" do
    it "is valid" do
      template.handler = 'notknown'
      expect(template).to_not be_valid
      expect(template.errors[:handler].size).to eq(1)
    end

    it "is present" do
      template.handler = nil
      expect(template).to_not be_valid
      expect(template.errors[:handler].size).to eq(1)
    end
  end

  context "cache" do
    before do
      DatabaseTemplate.delete_all
    end

    it "is expired on update" do
      resolver = DatabaseTemplate.resolver

      cache_key = Object.new
      db_template = FactoryBot.create(:database_template, :path => 'foo/some_list', :body => 'Listing something')

      details   = { :formats => [:html], :locale => [:en], :handlers => [:erb] }

      template = resolver.find_all("some_list", "foo", false, details, cache_key).first
      expect(template.source).to match(/Listing something/)

      db_template.update_attributes(:body => "New body for template")

      template = resolver.find_all("some_list", "foo", false, details, cache_key).first
      expect(template.source).to match(/New body for template/)
    end
  end

  context "#resolver" do
    it "#returns a Resolver instance" do
      expect(DatabaseTemplate.resolver).to be_a(Panoramic::Resolver)
    end
  end

  context "ActiveRecord::Base" do
    it "responds to store_templates" do
      expect(ActiveRecord::Base).to respond_to(:store_templates)
    end
  end
end
