require 'spec_helper'

describe CartsController do
  controller_actions = controller_actions("carts")

  before(:each) do
    @model = Factory(:cart)
    @other = Factory(:cart)
    session[:cartid] = @model.id
  end

  describe "no user is logged in" do
    controller_actions.each do |action,req|
      if %w(show update destroy).include?(action)
        it "should reach his own #{action} page" do
          send("#{req}", "#{action}", :id => @model.id)
          response.redirect_url.should_not eq welcome_url
        end
        it "should not reach someone else's #{action} page" do
          send("#{req}", "#{action}", :id => @other.id)
          response.redirect_url.should eq welcome_url
          flash.alert.should eq "Invalid cart."
        end
        it "should not reach an invalid #{action} page" do
          send("#{req}", "#{action}", :id => 666)
          response.redirect_url.should eq welcome_url
          flash.alert.should eq "Invalid cart."
        end
      else
        it "should not reach the #{action} page" do
          send("#{req}", "#{action}", :id => @model.id)
          response.redirect_url.should eq login_url 
        end
      end
    end
  end #no user is logged in

  describe "a user is logged in as" do
    context "member" do
      before(:each) do
        user = create_member
        session[:userid] = user.id
      end

      controller_actions.each do |action,req|
        if %w(show update destroy).include?(action)
          it "should reach his own #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          it "should not reach someone else's #{action} page" do
            send("#{req}", "#{action}", :id => @other.id)
            response.redirect_url.should eq welcome_url
            flash.alert.should eq "Invalid cart."
          end
          it "should not reach an invalid #{action} page" do
            send("#{req}", "#{action}", :id => 666)
            response.redirect_url.should eq welcome_url
            flash.alert.should eq "Invalid cart."
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end #member

    context "vip" do
      before(:each) do
        user = create_vip
        session[:userid] = user.id
      end

      controller_actions.each do |action,req|
        if %w(show update destroy).include?(action)
          it "should reach his own #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          it "should not reach someone else's #{action} page" do
            send("#{req}", "#{action}", :id => @other.id)
            response.redirect_url.should eq welcome_url
            flash.alert.should eq "Invalid cart."
          end
          it "should not reach an invalid #{action} page" do
            send("#{req}", "#{action}", :id => 666)
            response.redirect_url.should eq welcome_url
            flash.alert.should eq "Invalid cart."
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end #vip

    context "miniadmin" do
      before(:each) do
        user = create_miniadmin
        session[:userid] = user.id
      end

      controller_actions.each do |action,req|
        if %w(show update destroy).include?(action)
          it "should reach his own #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          it "should not reach someone else's #{action} page" do
            send("#{req}", "#{action}", :id => @other.id)
            response.redirect_url.should eq welcome_url
            flash.alert.should eq "Invalid cart."
          end
          it "should not reach an invalid #{action} page" do
            send("#{req}", "#{action}", :id => 666)
            response.redirect_url.should eq welcome_url
            flash.alert.should eq "Invalid cart."
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should eq welcom_url 
          end
        end
      end
    end #miniadmin

    context "admin" do
      before(:each) do
        user = create_admin
        session[:userid] = user.id
      end

      controller_actions.each do |action,req|
        if %w(show update destroy).include?(action)
          it "should reach his own #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          it "should reach someone else's #{action} page" do
            send("#{req}", "#{action}", :id => @other.id)
            response.redirect_url.should_not eq welcome_url
            flash.alert.should be_nil 
          end
          it "should not reach an invalid #{action} page" do
            send("#{req}", "#{action}", :id => 666)
            response.redirect_url.should eq welcome_url
            flash.alert.should eq "Invalid cart."
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should eq weclome_url 
          end
        end
      end
    end #admin

    context "god" do
      before(:each) do
        user = create_god
        session[:userid] = user.id
      end

      controller_actions.each do |action,req|
        if %w(show update destroy).include?(action)
          it "should reach his own #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
          it "should reach someone else's #{action} page" do
            send("#{req}", "#{action}", :id => @other.id)
            response.redirect_url.should_not eq welcome_url
            flash.alert.should be_nil 
          end
          it "should not reach an invalid #{action} page" do
            send("#{req}", "#{action}", :id => 666)
            response.redirect_url.should eq welcome_url
            flash.alert.should eq "Invalid cart."
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end #god
  end #user is logged in as
end
