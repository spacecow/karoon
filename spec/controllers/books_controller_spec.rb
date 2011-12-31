require 'spec_helper'

describe BooksController do
  controller_actions = controller_actions("books")

  before(:each) do
    @model = Factory(:book)
  end

  describe "a user is not logged in" do
    controller_actions.each do |action,req|
      if %(index).include?(action)
        it "should reach the #{action} page" do
          send("#{req}", "#{action}", :id => @model.id)
          response.redirect_url.should be_nil
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
    context "admin" do
      before(:each) do
        user = create_admin
        session[:userid] = user.id
      end

      controller_actions.each do |action,req|
        if %(index new create).include?(action)
          it "should reach the #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should be_nil
          end
        else
          it "should not reach the #{action} page" do
            send("#{req}", "#{action}", :id => @model.id)
            response.redirect_url.should eq welcome_url 
          end
        end
      end
    end
  end
end
