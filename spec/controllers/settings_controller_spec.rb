require 'spec_helper'

describe SettingsController do
  controller_actions = controller_actions("settings")

  before(:each) do
    @model = Setting.singleton 
  end

  describe "a user is not logged in" do
    controller_actions.each do |action,req|
      if %w().include?(action)
        it "should reach the #{action} page" do
          send("#{req}", "#{action}", :id => @model.id)
          response.redirect_url.should_not eq welcome_url
        end
      else
        it "should not reach the #{action} page" do
          send("#{req}", "#{action}", :id => @model.id)
          response.redirect_url.should eq login_url 
        end
      end
    end
  end

  describe "a user is logged in as" do
    context "member" do
      before(:each) do
        session[:userid] = create_member.id
      end
      controller_actions.each do |action,req|
        if %w().include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
        else
          it "should not reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end

    context "vip" do
      before(:each) do
        session[:userid] = create_vip.id
      end
      controller_actions.each do |action,req|
        if %w().include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
        else
          it "should not reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end

    context "admin" do
      before(:each) do
        session[:userid] = create_admin.id
      end
      controller_actions.each do |action,req|
        if %w(edit update).include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
        else
          it "should not reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end

    context "god" do
      before(:each) do
        session[:userid] = create_god.id
      end
      controller_actions.each do |action,req|
        if %w(edit update).include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
        else
          it "should not reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end
  end
end
