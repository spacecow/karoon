require 'spec_helper'

describe "Orders, index:" do
  context "member layout without orders" do
    before(:each) do
      login_member
      visit orders_path
    end

    it "has a title" do
      page.should have_title('All Orders')
    end

    it "has no table with the orders" do
      page.should_not have_a_table(:orders)
    end
  end #member layout without orders

  context "member layout with own draft orders" do
    before(:each) do
      member = login_member
      other = create_member
      other_order = Factory(:order, user_id:other.id)
      other_book  = Factory(:book,title:'An other book')
      Factory(:line_item, order_id:other_order.id, book_id:other_book.id)

      draft_order = Factory(:order, user_id:member.id)
      draft_book  = Factory(:book,title:'A draft book')
      Factory(:line_item, order_id:draft_order.id, book_id:draft_book.id)

      confirmed_order = Factory(:order,user_id:member.id,:aasm_state => :confirmed)
      confirmed_book  = Factory(:book,title:'A confirmed book')
      Factory(:line_item, order_id:confirmed_order.id, book_id:confirmed_book.id)

      visit orders_path(:status => :draft)
    end

    it "displays the member's draft book" do
      divs_no(:line_item).should be(1)
      div(:line_item,0).should have_content("A draft book")
    end
  end

  context "member layout with own confirmed orders" do
    before(:each) do
      member = login_member
      other = create_member
      other_order = Factory(:order, user_id:other.id, :aasm_state => :confirmed)
      other_book  = Factory(:book,title:'An other book')
      Factory(:line_item, order_id:other_order.id, book_id:other_book.id)
      draft_order = Factory(:order, user_id:member.id)
      draft_book  = Factory(:book,title:'A draft book')
      Factory(:line_item, order_id:draft_order.id, book_id:draft_book.id)
      confirmed_order = Factory(:order,user_id:member.id,:aasm_state => :confirmed)
      confirmed_book  = Factory(:book,title:'A confirmed book')
      Factory(:line_item, order_id:confirmed_order.id, book_id:confirmed_book.id)
      visit orders_path(:status => :confirmed)
    end

    it "displays the member's confirmed book" do
      divs_no(:line_item).should be(1)
      div(:line_item,0).should have_content("A confirmed book")
    end
  end

  context "member layout with orders" do
    before(:each) do
      own   = login_member
      order = Factory(:order, user_id:own.id,created_at:Time.now-1.hour, updated_at:Time.now-30.minute)
      order2 = Factory(:order, user_id:own.id, :aasm_state => :confirmed, created_at:Time.parse('2011-3-4 11:00'), updated_at:Time.parse('2011-3-4 12:00'))
      book  = Factory(:book,title:'A new book', regular_price:12000)
      Factory(:line_item, order_id:order.id, book_id:book.id)
      Factory(:line_item, order_id:order2.id, book_id:book.id)

      #user  = Factory(:user)
      #Factory(:order,user_id:user.id) 
      visit orders_path
    end

    it "has no table with the orders" do
      page.should_not have_a_table(:orders)
    end

    #it "has tableheaders" do
    #  tableheader(:orders).should eq ["Items","Price (Toman)","Status","Created at","Updated at"]
    #end

    it "has a div for each own order" do
      divs_no(:line_item).should be(2)
    end

    #it "info about the order on each line" do
    #  tablemap(:orders).should eq [["A new book","12000","draft","about 1 hour ago","30 minutes ago","Edit"],["A new book","12000","confirmed","about 1 year ago","about 1 year ago",""]]
    #end

    #it "has a link to a detailed order page" do
    #  row(1,:orders).should have_link('A new book')
    #end

    it "has an edit link for the draft order" do
      div(:order,0).should have_link('Edit')
    end

    it "has no edit link for the confirmed order" do
      div(:order,1).should_not have_link('Edit')
    end
  end

  context "admin layout with orders" do
    before(:each) do
      own   = login_admin
      order = Factory(:order, user_id:own.id,created_at:Time.parse('2011-3-4 11:00'), updated_at:Time.parse('2011-3-4 12:00'))
      book  = Factory(:book,title:'A new book')
      Factory(:line_item, order_id:order.id, book_id:book.id)

      user   = Factory(:user)
      order2 = Factory(:order,user_id:user.id) 
      book2  = Factory(:book,title:'A second book')
      Factory(:line_item, order_id:order2.id, book_id:book2.id)
      visit orders_path
    end

    it "displays all order" do
      divs_no(:order).should be(2)
    end
  end
end
