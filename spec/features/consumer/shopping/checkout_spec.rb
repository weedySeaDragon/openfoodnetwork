require 'spec_helper'

include AuthenticationWorkflow
include WebHelper

feature "As a consumer I want to check out my cart", js: true do
  let(:distributor) { create(:distributor_enterprise) }
  let(:supplier) { create(:supplier_enterprise) }
  let(:order_cycle) { create(:order_cycle, distributors: [distributor], coordinator: create(:distributor_enterprise)) }
  let(:product) { create(:simple_product, supplier: supplier) }

  before do
    create_enterprise_group_for distributor
    exchange = Exchange.find(order_cycle.exchanges.to_enterprises(distributor).outgoing.first.id) 
    exchange.variants << product.master
  end

  describe "Attempting to access checkout without meeting the preconditions" do
    it "redirects to the homepage if no distributor is selected" do
      visit "/shop/checkout"
      current_path.should == root_path
    end

    it "redirects to the shop page if we have a distributor but no order cycle selected" do
      select_distributor
      visit "/shop/checkout"
      current_path.should == shop_path
    end

    it "redirects to the shop page if the current order is empty" do
      select_distributor
      select_order_cycle
      visit "/shop/checkout"
      current_path.should == shop_path
    end

    it "renders checkout if we have distributor and order cycle selected" do
      select_distributor
      select_order_cycle
      add_product_to_cart
      visit "/shop/checkout"
      current_path.should == "/shop/checkout"
    end
  end

  describe "Login behaviour" do
    let(:user) { create_enterprise_user }
    before do
      select_distributor
      select_order_cycle
      add_product_to_cart
    end

    it "renders the login form if user is logged out" do
      visit "/shop/checkout"
      within "section[role='main']" do
        page.should have_content "I HAVE AN OFN ACCOUNT"
      end
    end

    it "does not not render the login form if user is logged in" do
      login_to_consumer_section
      visit "/shop/checkout"
      within "section[role='main']" do
        page.should_not have_content "I HAVE AN OFN ACCOUNT"
      end
    end

    it "renders the signup link if user is logged out" do
      visit "/shop/checkout"
      within "section[role='main']" do
        page.should have_content "NEW TO OFN"
      end
    end

    it "does not not render the signup form if user is logged in" do
      login_to_consumer_section
      visit "/shop/checkout"
      within "section[role='main']" do
        page.should_not have_content "NEW TO OFN"
      end
    end

    it "redirects to the checkout page when logging in from the checkout page" do
      visit "/shop/checkout"
      within "#checkout_login" do
        fill_in "spree_user[email]", with: user.email 
        fill_in "spree_user[password]", with: user.password 
        click_button "Login"
      end

      current_path.should == "/shop/checkout"
      within "section[role='main']" do
        page.should_not have_content "I have an OFN Account"
      end
    end

    it "redirects to the checkout page when signing up from the checkout page" do
      visit "/shop/checkout"
      within "#checkout_signup" do
        fill_in "spree_user[email]", with: "test@gmail.com" 
        fill_in "spree_user[password]", with: "password" 
        fill_in "spree_user[password_confirmation]", with: "password" 
        click_button "Sign Up"
      end
      current_path.should == "/shop/checkout"
      within "section[role='main']" do
        page.should_not have_content "Sign Up"
      end
    end
  end

  describe "logged in, distributor selected, order cycle selected, product in cart" do
    let(:user) { create_enterprise_user }
    before do
      login_to_consumer_section
      select_distributor
      select_order_cycle
      add_product_to_cart
    end

    describe "with shipping methods" do
      let(:sm1) { create(:shipping_method, require_ship_address: true, name: "Frogs", description: "yellow") }
      let(:sm2) { create(:shipping_method, require_ship_address: true, name: "Donkeys", description: "blue") }
      before do
        distributor.shipping_methods << sm1 
        distributor.shipping_methods << sm2 
        visit "/shop/checkout"
      end
      it "shows all shipping methods" do
        page.should have_content "Frogs"
        page.should have_content "Donkeys"
      end

      it "doesn't show ship address forms by default" do
        find("#ship_address").visible?.should be_false
      end

      it "shows ship address forms when selected shipping method requires one" do
        # Fancy Foundation Forms are weird
        choose(sm1.name)
        find("#ship_address").visible?.should be_true
      end
    end

    describe "with payment methods" do
      let(:pm1) { create(:payment_method, distributors: [distributor]) }
      let(:pm2) { create(:payment_method, distributors: [distributor]) }

      before do
        pm1 # Lazy evaluation of ze create()s
        pm2
        visit "/shop/checkout"
      end

      it "shows all available payment methods" do
        page.should have_content pm1.name
        page.should have_content pm2.name
      end

      describe "Purchase" do
        it "re-renders with errors when we submit the incomplete form" do
          click_button "Purchase"
          current_path.should == "/shop/checkout"
          page.should have_content "We could not process your order"
        end
      end
    end
  end
end


def select_distributor
  visit "/"
  click_link distributor.name
end

def select_order_cycle
  exchange = Exchange.find(order_cycle.exchanges.to_enterprises(distributor).outgoing.first.id) 
  visit "/shop"
  select exchange.pickup_time, from: "order_cycle_id"
end

def add_product_to_cart

  fill_in "variants[#{product.master.id}]", with: 5
  first("form.custom > input.button.right").click 
end