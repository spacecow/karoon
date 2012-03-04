require 'spec_helper'

describe OrdersController do
  controller_actions = controller_actions("orders")

  describe "a user is not logged in" do
    before(:each) do
      user = create_member
      @model = Factory(:order,:user_id=>user.id)
    end
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
        user = create_member
        session[:userid] = user.id
        @model = Factory(:order,:user_id=>user.id)
        @other = Factory(:order,:user_id=>create_member(:email=>'other@email.com').id)
      end
      controller_actions.each do |action,req|
        if %w(new create index).include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
        elsif %w(show validate confirm edit update).include?(action)
          it "should reach the own #{action} page if 'draft'" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          if %w(show).include?(action)
            it "should reach the own #{action} page if 'confirmed'" do
              @model.order_confirmed!
              send(req, action, :id => @model.id)
              response.redirect_url.should_not eq welcome_url
            end
          else
            it "should not reach the own #{action} page if 'confirmed'" do
              @model.order_confirmed!
              send(req, action, :id => @model.id)
              response.redirect_url.should eq welcome_url
            end
          end
          it "should not reach other's #{action} page" do
            send(req, action, :id => @other.id)
            response.redirect_url.should eq welcome_url
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
        user = create_vip
        session[:userid] = user.id
        @model = Factory(:order,:user_id=>user.id)
        @other = Factory(:order,:user_id=>create_member(:email=>'other@email.com').id)
      end
      controller_actions.each do |action,req|
        if %w(new create index).include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
        elsif %w(show validate confirm edit update).include?(action)
          it "should reach the own #{action} page if 'draft'" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          if %w(show).include?(action)
            it "should reach the own #{action} page if 'confirmed'" do
              @model.order_confirmed!
              send(req, action, :id => @model.id)
              response.redirect_url.should_not eq welcome_url
            end
          else
            it "should not reach the own #{action} page if 'confirmed'" do
              @model.order_confirmed!
              send(req, action, :id => @model.id)
              response.redirect_url.should eq welcome_url
            end
          end
          it "should not reach other's #{action} page" do
            send(req, action, :id => @other.id)
            response.redirect_url.should eq welcome_url
          end
        else
          it "should not reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end

    context "miniadmin" do
      before(:each) do
        user = create_miniadmin
        session[:userid] = user.id
        @model = Factory(:order,:user_id=>user.id)
        @other = Factory(:order,:user_id=>create_member(:email=>'other@email.com').id)
      end
      controller_actions.each do |action,req|
        if %w(new create index).include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id, :books => {"0" => {:title => "Title"}})
            response.redirect_url.should_not eq welcome_url
          end
        elsif %w(show validate confirm edit update).include?(action)
          it "should reach the own #{action} page if 'draft'" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          if %w(show).include?(action)
            it "should reach the own #{action} page if 'confirmed'" do
              @model.order_confirmed!
              send(req, action, :id => @model.id)
              response.redirect_url.should_not eq welcome_url
            end
          else
            it "should not reach the own #{action} page if 'confirmed'" do
              @model.order_confirmed!
              send(req, action, :id => @model.id)
              response.redirect_url.should eq welcome_url
            end
          end
          it "should not reach other's #{action} page" do
            send(req, action, :id => @other.id)
            response.redirect_url.should eq welcome_url
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
        user = create_admin
        session[:userid] = user.id
        @model = Factory(:order,:user_id=>user.id)
        @other = Factory(:order,:user_id=>create_member(:email=>'other@email.com').id)
      end
      controller_actions.each do |action,req|
        if %w(new create index).include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id, :books => {"0" => {:title => "Title"}})
            response.redirect_url.should_not eq welcome_url
          end
        elsif %w(show validate confirm edit update).include?(action)
          it "should reach the own #{action} page if 'draft'" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          it "should reach the own #{action} page if 'confirmed'" do
            @model.order_confirmed!
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          it "should reach other's #{action} page" do
            send(req, action, :id => @other.id)
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
        user = create_god
        session[:userid] = user.id
        @model = Factory(:order,:user_id=>user.id)
        @other = Factory(:order,:user_id=>create_member(:email=>'other@email.com').id)
      end
      controller_actions.each do |action,req|
        if %w(new create index).include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id, :books => {"0" => {:title => "Title"}})
            response.redirect_url.should_not eq welcome_url
          end
        elsif %w(show validate confirm edit update).include?(action)
          it "should reach the own #{action} page if 'draft'" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          it "should reach the own #{action} page if 'confirmed'" do
            @model.order_confirmed!
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          it "should reach other's #{action} page" do
            send(req, action, :id => @other.id)
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
