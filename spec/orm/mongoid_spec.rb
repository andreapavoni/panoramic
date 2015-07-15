require 'spec_helper'

if defined? Mongoid
  describe Panoramic::Orm::Mongoid do
    context "validations" do
      let(:template) { FactoryGirl.build :database_template }

      it "has body present" do
        template.body = nil
        template.should have(1).errors_on(:body)
      end

      context "MIME format" do
        it "is valid" do
          template.format = 'notknown'
          template.should have(1).errors_on(:format)
        end

        it "is present" do
          template.format = nil
          template.should have(1).errors_on(:format)
        end
      end

      context "locale" do
        it "is valid" do
          template.locale = 'notknown'
          template.should have(1).errors_on(:locale)
        end

        it "does not need to be present" do
          template.locale = nil
          template.should have(0).errors_on(:locale)
        end
      end

      context "handler" do
        it "is valid" do
          template.handler = 'notknown'
          template.should have(1).errors_on(:handler)
        end

        it "is present" do
          template.handler = nil
          template.should have(1).errors_on(:handler)
        end
      end
    end

    context "cache" do
      before do
        DatabaseTemplate.delete_all
      end

      it "is expired on update" do
        resolver = DatabaseTemplate.resolver

        cache_key = Object.new
        db_template = FactoryGirl.create(:database_template, :path => 'foo/some_list', :body => 'Listing something')

        details   = { :formats => [:html], :locale => [:en], :handlers => [:erb] }

        template = resolver.find_all("some_list", "foo", false, details, cache_key).first
        template.source.should match(/Listing something/)

        db_template.update_attributes(:body => "New body for template")

        template = resolver.find_all("some_list", "foo", false, details, cache_key).first
        template.source.should match(/New body for template/)
      end
    end

    context "#resolver" do
      it "#returns a Resolver instance" do
        DatabaseTemplate.resolver.should be_a(Panoramic::Resolver)
      end
    end
  end
end
