require 'spec_helper'

describe TranslationsController do
  controller_actions = controller_actions("translations")

  describe "a user is not logged in" do
    controller_actions.each do |action,req|
      if %w().include?(action)
        it "should reach the #{action} page" do
          send("#{req}", "#{action}")
          response.redirect_url.should_not eq login_url
        end
      else
        it "should not reach the #{action} page" do
          send("#{req}", "#{action}")
          response.redirect_url.should eq login_url 
        end
      end
    end
  end #a user is not logged in

  describe "a user is logged in as" do
    context "member" do
      before(:each) do
        session[:userid] = create_member.id
      end
      controller_actions.each do |action,req|
        if %w().include?(action)
          it "should reach the #{action} page" do
            send("#{req}", "#{action}")
            response.redirect_url.should_not eq welcome_url
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}")
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end #member

    context "vip" do
      before(:each) do
        session[:userid] = create_vip.id
      end
      controller_actions.each do |action,req|
        if %w().include?(action)
          it "should reach the #{action} page" do
            send("#{req}", "#{action}")
            response.redirect_url.should_not eq welcome_url
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}")
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end #vip

    context "miniadmin" do
      before(:each) do
        session[:userid] = create_miniadmin.id
      end
      controller_actions.each do |action,req|
        if %w().include?(action)
          it "should reach the #{action} page" do
            send("#{req}", "#{action}")
            response.redirect_url.should_not eq welcome_url
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}")
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end #miniadmin

    context "admin" do
      before(:each) do
        session[:userid] = create_admin.id
      end
      controller_actions.each do |action,req|
        if %w(create index update_multiple).include?(action)
          it "should reach the #{action} page" do
            send("#{req}", "#{action}")
            response.redirect_url.should_not eq welcome_url
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}")
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end #admin

    context "god" do
      before(:each) do
        session[:userid] = create_god.id
      end
      controller_actions.each do |action,req|
        if %w(create index update_multiple).include?(action)
          it "should reach the #{action} page" do
            send("#{req}", "#{action}")
            response.redirect_url.should_not eq welcome_url
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}")
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end #god
  end #a user is logged in
end
