require 'spec_helper'

describe BooksController do
  controller_actions = controller_actions("books")

  before(:each) do
    @model = Factory(:book)
  end

  describe "a user is not logged in" do
    controller_actions.each do |action,req|
      if %w(show index who_bought).include?(action)
        it "should reach the #{action} page" do
          send("#{req}", "#{action}", :id => @model.id)
          response.redirect_url.should_not eq login_url
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
        if %w(show index who_bought).include?(action)
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
        if %w(show index who_bought).include?(action)
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

    context "miniadmin" do
      before(:each) do
        session[:userid] = create_miniadmin.id
      end
      controller_actions.each do |action,req|
        if %w(show index who_bought).include?(action)
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
        if %w(show index new create edit update destroy create_individual who_bought).include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id, :books => {"0" => {:title => "Title"}})
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
        if %w(show index new create edit update destroy create_individual who_bought).include?(action)
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id, :books => {"0" => {:title => "Title"}})
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
