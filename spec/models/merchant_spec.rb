require 'rails_helper'

RSpec.describe Merchant, type: :model do
  before :each do
    # Customers:
    @salim     = Customer.create!(first_name: 'Salim', last_name: 'Imwera', address: 'Up The Hill, Kwale, Kenya')
    @sally     = Customer.create!(first_name: 'Sally', last_name: 'Smith', address: 'Test Address')
    # Merchants:
    @amazon      = Merchant.create!(name: 'Amazon')
    @max         = Merchant.create!(name: 'Merch Max')
    @all_birds   = Merchant.create!(name: 'All Birds')
    @happy_cones = Merchant.create!(name: 'Happy Cones')
    @happy_drink = Merchant.create!(name: 'Happy Drink')
    # Invoices:
    @invoice1  = Invoice.create!(status: 1, customer_id: @sally.id, merchant_id: @max.id)
    @invoice2  = Invoice.create!(status: 1, customer_id: @sally.id, merchant_id: @max.id)
    @invoice5  = Invoice.create!(status: 2, customer_id: @salim.id, merchant_id: @amazon.id, created_at: 'Fri, 08 Dec 2020 14:42:18 UTC +00:00')
    @invoice6  = Invoice.create!(status: 2, customer_id: @sally.id, merchant_id: @all_birds.id, created_at: 'Fri, 08 Dec 2020 14:42:18 UTC +00:00')
    @invoice7  = Invoice.create!(status: 2, customer_id: @sally.id, merchant_id: @happy_cones.id, created_at: 'Fri, 08 Dec 2020 14:42:18 UTC +00:00')
    @invoice8  = Invoice.create!(status: 2, customer_id: @sally.id, merchant_id: @happy_drink.id, created_at: 'Fri, 08 Dec 2020 14:42:18 UTC +00:00')
    # Items:
    @item_1        = @max.items.create!(name: 'Beans', description: 'Tasty', unit_price: 5)
    @item_2        = @max.items.create!(name: 'Item 2', description: 'Blah', unit_price: 10)
    @item_3        = @max.items.create!(name: 'Item 3', description: 'Test', unit_price: 15)
    @backpack      = @amazon.items.create!(name: 'Camo Backpack', description: 'Double Zip Backpack', unit_price: 5.0)
    @radio         = @amazon.items.create!(name: 'Retro Radio', description: 'Twist and Turn to your fav jams', unit_price: 10.0)
    @shoes         = @all_birds.items.create!(name: 'Pink Shoes', description: 'Light and warm booties!', unit_price: 120.0)
    @ice_cream     = @happy_cones.items.create!(name: 'Hockey Pokey', description: 'Toffee bits in vanilla ice cream.', unit_price: 3.0)
    @drink         = @happy_drink.items.create!(name: 'Hockey Pokey', description: 'Toffee bits in vanilla ice cream.', unit_price: 3.0)
    # InvoiceItems:
    @invitm1   = InvoiceItem.create!(status: 0, quantity: 25, unit_price: 7.0, invoice_id: @invoice1.id, item_id: @item_1.id)
    @invitm2   = InvoiceItem.create!(status: 2, quantity: 10, unit_price: 15.5, invoice_id: @invoice2.id, item_id: @item_2.id)
    @invitm3   = InvoiceItem.create!(status: 0, quantity: 25, unit_price: 10, invoice_id: @invoice1.id, item_id: @item_2.id)
    @invitm4   = InvoiceItem.create!(status: 2, quantity: 50, unit_price: 5.0, invoice_id: @invoice5.id, item_id: @backpack.id)
    @invitm5   = InvoiceItem.create!(status: 1, quantity: 100, unit_price: 10.0, invoice_id: @invoice5.id, item_id: @radio.id)
    @invitm6   = InvoiceItem.create!(status: 1, quantity: 5, unit_price: 10.0, invoice_id: @invoice5.id, item_id: @item_3.id)
    @invitm7   = InvoiceItem.create!(status: 1, quantity: 10, unit_price: 120.0, invoice_id: @invoice6.id, item_id: @shoes.id)
    @invitm8   = InvoiceItem.create!(status: 1, quantity: 4, unit_price: 3.0, invoice_id: @invoice7.id, item_id: @ice_cream.id)
    @invitm9   = InvoiceItem.create!(status: 1, quantity: 4, unit_price: 3.0, invoice_id: @invoice8.id, item_id: @drink.id)
    # Discounts:
    @discount_1 = Discount.create!(discount_percentage: 5, quantity_threshold: 10, merchant_id: @all_birds.id)
    @discount_2 = Discount.create!(discount_percentage: 15, quantity_threshold: 15, merchant_id: @amazon.id)
    @discount_3 = Discount.create!(discount_percentage: 20, quantity_threshold: 10, merchant_id: @amazon.id)
    @discount_4 = Discount.create!(discount_percentage: 20, quantity_threshold: 15, merchant_id: @max.id)
    @discount_5 = Discount.create!(discount_percentage: 30, quantity_threshold: 15, merchant_id: @max.id)
    @discount_6 = Discount.create!(discount_percentage: 5, quantity_threshold: 10, merchant_id: @happy_cones.id)
    @discount_7 = Discount.create!(discount_percentage: 2, quantity_threshold: 4, merchant_id: @happy_cones.id)
  end
  describe 'validations' do
    it { should validate_presence_of :name}
  end

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :invoices}
    it {should have_many :discounts}
    it {should have_many(:customers).through(:invoices)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:invoice_items).through(:items)}
  end

  describe 'instance methods' do
    describe 'top_five_customers' do
      it "a merchant can identify its top 5 customer names" do
        sally    = Customer.create!(first_name: 'Sally', last_name: 'Smith')
        joel     = Customer.create!(first_name: 'Joel', last_name: 'Hansen')
        john     = Customer.create!(first_name: 'John', last_name: 'Hansen')
        travolta = Customer.create!(first_name: 'Travolta', last_name: 'Hansen')
        sal      = Customer.create!(first_name: 'Sal', last_name: 'Hansen')
        tim      = Customer.create!(first_name: 'Tim', last_name: 'Hansen')
        amazon   = Merchant.create!(name: 'Amazon')
        alibaba  = Merchant.create!(name: 'Alibaba')
        invoice1 = Invoice.create!(status: 1, customer_id: sally.id, merchant_id: amazon.id)
        invoice2 = Invoice.create!(status: 1, customer_id: sally.id, merchant_id: amazon.id)
        invoice3 = Invoice.create!(status: 1, customer_id: joel.id, merchant_id: amazon.id)
        invoice4 = Invoice.create!(status: 1, customer_id: joel.id, merchant_id: amazon.id)
        invoice5 = Invoice.create!(status: 1, customer_id: john.id, merchant_id: amazon.id)
        invoice6 = Invoice.create!(status: 1, customer_id: john.id, merchant_id: amazon.id)
        invoice7 = Invoice.create!(status: 1, customer_id: travolta.id, merchant_id: amazon.id)
        invoice8 = Invoice.create!(status: 1, customer_id: travolta.id, merchant_id: amazon.id)
        invoice9 = Invoice.create!(status: 1, customer_id: sal.id, merchant_id: amazon.id)
        invoice10 = Invoice.create!(status: 1, customer_id: sal.id, merchant_id: amazon.id)
        invoice11 = Invoice.create!(status: 1, customer_id: tim.id, merchant_id: amazon.id)
        invoice13 = Invoice.create!(status: 0, customer_id: sally.id, merchant_id: amazon.id)
        invoice14 = Invoice.create!(status: 0, customer_id: sally.id, merchant_id: alibaba.id)
        tx1      = Transaction.create!(result: "success", credit_card_number: 010001001022, credit_card_expiration_date: 20251001, invoice_id: invoice2.id,)
        tx2      = Transaction.create!(result: "success", credit_card_number: 010001005555, credit_card_expiration_date: 20220101, invoice_id: invoice1.id,)
        tx3      = Transaction.create!(result: "success", credit_card_number: 010001005551, credit_card_expiration_date: 20220101, invoice_id: invoice3.id,)
        tx4      = Transaction.create!(result: "success", credit_card_number: 010001005552, credit_card_expiration_date: 20220101, invoice_id: invoice4.id,)
        tx5      = Transaction.create!(result: "success", credit_card_number: 010001005553, credit_card_expiration_date: 20220101, invoice_id: invoice5.id,)
        tx6      = Transaction.create!(result: "success", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice6.id,)
        tx7      = Transaction.create!(result: "success", credit_card_number: 010001005550, credit_card_expiration_date: 20220101, invoice_id: invoice7.id,)
        tx8      = Transaction.create!(result: "success", credit_card_number: 010001005556, credit_card_expiration_date: 20220101, invoice_id: invoice8.id,)
        tx9      = Transaction.create!(result: "success", credit_card_number: 010001005557, credit_card_expiration_date: 20220101, invoice_id: invoice9.id,)
        tx10     = Transaction.create!(result: "success", credit_card_number: 010001005523, credit_card_expiration_date: 20220101, invoice_id: invoice10.id,)
        tx11     = Transaction.create!(result: "success", credit_card_number: 0100010055, credit_card_expiration_date: 20220101, invoice_id: invoice11.id,)
        tx12     = Transaction.create!(result: "failure", credit_card_number: 0100010055, credit_card_expiration_date: 20220101, invoice_id: invoice14.id,)
        candle   = Item.create!(name: 'Lavender Candle', description: '8oz Soy Candle', unit_price: 7.0, merchant_id: amazon.id)
        backpack = Item.create!(name: 'Camo Backpack', description: 'Double Zip Backpack', unit_price: 15.5, merchant_id: alibaba.id)
        invitm1  = InvoiceItem.create!(status: 0, quantity: 25, unit_price: 7.0, invoice_id: invoice1.id, item_id: candle.id)
        invitm2  = InvoiceItem.create!(status: 0, quantity: 10, unit_price: 15.5, invoice_id: invoice2.id, item_id: backpack.id)

        expected_names = [sally.first_name, joel.first_name, john.first_name, travolta.first_name, sal.first_name]
        expected_successful_transaction_counts = [2, 2, 2, 2, 2]

        actual_names = amazon.top_five_customers.map do |customer|
          customer.first_name
        end

        actual_successful_transaction_counts = amazon.top_five_customers.map do |customer|
          customer.successful_transactions
        end

        expect(actual_names).to eq(expected_names)
        expect(actual_successful_transaction_counts).to eq(expected_successful_transaction_counts)
      end
    end

    describe 'items_ready_to_ship' do
      it 'returns an array of all the names of my items that have been ordered and have not yet been shipped' do
        max = Merchant.create!(name: 'Merch Max')
        item_1 = max.items.create!(name: 'Beans', description: 'Tasty', unit_price: 5)
        item_2 = max.items.create!(name: 'Item 2', description: 'Blah', unit_price: 10)
        item_3 = max.items.create!(name: 'Item 3', description: 'Test', unit_price: 15)

        sally    = Customer.create!(first_name: 'Sally', last_name: 'Smith')
        invoice1 = Invoice.create!(status: 1, customer_id: sally.id, merchant_id: max.id)

        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item_1.id, quantity: 1, unit_price: 5, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item_2.id, quantity: 1, unit_price: 10, status: 1)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item_3.id, quantity: 1, unit_price: 15, status: 2)

        actual_items = max.items_ready_to_ship

        expected_items = [item_1, item_2]

        expect(actual_items).to eq(expected_items)
      end
    end

    describe 'order invoices' do
      it "can order by created_at date" do
        max = Merchant.create!(name: 'Merch Max')
        item_1 = max.items.create!(name: 'Beans', description: 'Tasty', unit_price: 5)
        item_2 = max.items.create!(name: 'Item 2', description: 'Blah', unit_price: 10)
        item_3 = max.items.create!(name: 'Item 3', description: 'Test', unit_price: 15)
        item_4 = max.items.create!(name: 'Item 4', description: 'Item 4 Description...', unit_price: 20)

        sally    = Customer.create!(first_name: 'Sally', last_name: 'Smith')
        lisa    = Customer.create!(first_name: 'Lisa', last_name: 'John')
        invoice1 = Invoice.create!(status: 1, customer_id: sally.id, merchant_id: max.id, created_at: '2010-02-21 09:54:09 UTC')
        invoice2 = Invoice.create!(status: 1, customer_id: lisa.id, merchant_id: max.id, created_at: '2012-03-25 09:54:09 UTC')

        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item_1.id, quantity: 1, unit_price: 5, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item_2.id, quantity: 1, unit_price: 10, status: 1)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item_3.id, quantity: 1, unit_price: 15, status: 2)
        InvoiceItem.create!(invoice_id: invoice2.id, item_id: item_4.id, quantity: 1, unit_price: 20, status: 1)

        actual = max.order_merchant_items_by_invoice_created_date(max.items)

        expected = [item_1, item_2, item_3, item_4]

        expect(actual).to eq(expected)
      end
    end

    describe 'order by merchant status' do
      it "it can order by merhcant status enabled" do

        actual = Merchant.enabled_merchants
        expected = [@all_birds, @amazon, @happy_cones, @happy_drink, @max]
        expect(actual).to eq(expected)
      end

      it "it can order by merhcant status disabled" do
        Merchant.create!(name: 'Merch Max', status: 0)
        Merchant.create!(name: 'Merch Max', status: 0)
        merch_1 = Merchant.create!(name: 'Merch Max', status: 1)
        merch_2 = Merchant.create!(name: 'Merch Max', status: 1)

        actual = Merchant.disabled_merchants
        expected = [merch_1, merch_2]
        expect(actual).to eq(expected)
      end
    end

    describe 'enabled_items' do
      it "returns merchant items with a status of 'Enabled'" do
        merch_1 = Merchant.create!(name: 'Merch Max', status: 0)
        item_1 = merch_1.items.create!(name: 'Item 1', description: '1 description...', unit_price: 7, status: 0)
        item_2 = merch_1.items.create!(name: 'Item 2', description: '2 description...', unit_price: 5, status: 0)
        item_3 = merch_1.items.create!(name: 'Item 3', description: '3 description...', unit_price: 5, status: 1)

        expected = [item_1, item_2]

        actual = merch_1.enabled_items

        expect(actual).to eq(expected)
      end
    end

    describe 'disabled_items' do
      it "returns merchant items with a status of 'Disabled'" do
        merch_1 = Merchant.create!(name: 'Merch Max', status: 0)
        item_1 = merch_1.items.create!(name: 'Item 1', description: '1 description...', unit_price: 7, status: 0)
        item_2 = merch_1.items.create!(name: 'Item 2', description: '2 description...', unit_price: 5, status: 0)
        item_3 = merch_1.items.create!(name: 'Item 3', description: '3 description...', unit_price: 5, status: 1)

        expected = [item_3]

        actual = merch_1.disabled_items

        expect(actual).to eq(expected)
      end
    end

    describe 'Disabled Merchants' do
      it "returns merchant with a status of 'Disabled'" do
      # Customers:
        sally    = Customer.create!(first_name: 'Sally', last_name: 'Smith')
        joel     = Customer.create!(first_name: 'Joel', last_name: 'Hansen')
        billy    = Customer.create!(first_name: 'Billy', last_name: 'Joel')
        steve    = Customer.create!(first_name: 'Steve', last_name: 'Carrell')
        frank    = Customer.create!(first_name: 'Frank', last_name: 'Sinatra')
        jon      = Customer.create!(first_name: 'Jon', last_name: 'Travolta')
      # Merchants:
        amazon   = Merchant.create!(name: 'Amazon', status: 0)
        alibaba  = Merchant.create!(name: 'Alibaba', status: 1)
      # Invoices:
        invoice1 = Invoice.create!(status: 0, customer_id:  sally.id, merchant_id:   amazon.id, created_at: 'Fri, 08 Dec 2020 14:42:18 UTC +00:00')
        invoice2 = Invoice.create!(status: 0, customer_id:  joel.id, merchant_id:  alibaba.id)
        invoice3 = Invoice.create!(status: 0, customer_id:  billy.id, merchant_id:   alibaba.id)
        invoice4 = Invoice.create!(status: 0, customer_id:  steve.id, merchant_id:   amazon.id)
        invoice5 = Invoice.create!(status: 0, customer_id:  frank.id, merchant_id:   alibaba.id)
        invoice6 = Invoice.create!(status: 0, customer_id:  joel.id, merchant_id:  alibaba.id)
        invoice7 = Invoice.create!(status: 0, customer_id:  sally.id, merchant_id:   alibaba.id)
      # Transactions:
        tx1      = Transaction.create!(credit_card_number: 010001001022, credit_card_expiration_date: 20251001, result: 'success', invoice_id:  invoice2.id,)
        tx2      = Transaction.create!(credit_card_number: 010001005555, credit_card_expiration_date: 20220101, result: 'failed', invoice_id:   invoice1.id,)
        tx3      = Transaction.create!(credit_card_number: 010001001022, credit_card_expiration_date: 20251001, result: 'success', invoice_id:  invoice3.id,)
        tx4      = Transaction.create!(credit_card_number: 010001001022, credit_card_expiration_date: 20251001, result: 'success', invoice_id:  invoice4.id,)
        tx5      = Transaction.create!(credit_card_number: 010001005555, credit_card_expiration_date: 20220101, result: 'success', invoice_id:  invoice5.id,)
        tx6      = Transaction.create!(credit_card_number: 010001005555, credit_card_expiration_date: 20220101, result: 'success', invoice_id:  invoice5.id,)
        tx7      = Transaction.create!(credit_card_number: 010001005555, credit_card_expiration_date: 20220101, result: 'failed', invoice_id:   invoice6.id,)
        tx8      = Transaction.create!(credit_card_number: 010001005555, credit_card_expiration_date: 20220101, result: 'success', invoice_id:  invoice7.id,)
      # Items:
        candle   = Item.create!(name: 'Lavender Candle', description: '8oz Soy Candle', unit_price: 7.0, merchant_id:   amazon.id)
        backpack = Item.create!(name: 'Camo Backpack', description: 'Double Zip Backpack', unit_price: 15.5, merchant_id:   alibaba.id)
        radio    = Item.create!(name: 'Retro Radio', description: 'Twist and Turn to your fav jams', unit_price: 9.75, merchant_id:   amazon.id)
      # InvoiceItems:
        invitm1  = InvoiceItem.create!(status: 0, quantity: 25, unit_price: 7.0, invoice_id:  invoice1.id, item_id:  candle.id)
        invitm2  = InvoiceItem.create!(status: 2, quantity: 10, unit_price: 15.5, invoice_id:   invoice2.id, item_id:   backpack.id)
        invitm3  = InvoiceItem.create!(status: 1, quantity: 100, unit_price: 9.75, invoice_id:  invoice3.id, item_id:  backpack.id)

        expected = [alibaba]

        expect(Merchant.disabled_merchants).to eq(expected)
      end
    end

    describe 'Enabled Merchants' do
      it "returns merchant with a status of 'Enabled'" do
        expected = [@all_birds, @amazon, @happy_cones, @happy_drink, @max]

        expect(Merchant.enabled_merchants).to eq(expected)
      end
    end
    describe 'Top 5 Merchants Merchants' do
      it "returns the top 5 merchants in the system" do
        salim     = Customer.create!(first_name: 'Salim', last_name: 'Imwera', address: 'Up The Hill, Kwale, Kenya')
        sally     = Customer.create!(first_name: 'Sally', last_name: 'Smith', address: 'Test Address')
        manu      = Customer.create!(first_name: 'Manu', last_name: 'Chau', address: 'La Vida Loquisima, Cartagena, CO')
        logan     = Customer.create!(first_name: 'Logan', last_name: 'Rogan', address: 'This Is An Address, Aurora, CO')
        meegan    = Customer.create!(first_name: 'Meegan', last_name: 'Dap', address: 'This Is Also An Address, Denver, CO')
        saundra   = Customer.create!(first_name: 'Saundra', last_name: 'Peters', address: 'This Too Is An Address, Denver, CO')
        # Merchants:
        amazon    = Merchant.create!(name: 'Amazon', status: 0)
        max       = Merchant.create!(name: 'Merch Max', status: 1)
        alibaba   = Merchant.create!(name: 'Alibaba', status: 1)
        walmart   = Merchant.create!(name: 'Walmart', status: 0)
        overstock = Merchant.create!(name: 'Overstock', status: 0)
        spice_emp = Merchant.create!(name: 'Spice Emporium', status: 0)
        # Invoices:
        invoice1  = Invoice.create!(status: 1, customer_id: sally.id, merchant_id: max.id, created_at: 'Fri, 08 Dec 2020 14:42:18 UTC +00:00')
        invoice2  = Invoice.create!(status: 1, customer_id: sally.id, merchant_id: max.id, created_at: 'Sat, 16 Jan 2021 14:42:18 UTC +00:00')
        invoice3  = Invoice.create!(status: 1, customer_id: logan.id, merchant_id: alibaba.id, created_at: 'Sun, 17 Jan 2021 14:42:18 UTC +00:00')
        invoice4  = Invoice.create!(status: 1, customer_id: meegan.id, merchant_id: walmart.id, created_at: 'Fri, 15 Jan 2021 14:42:18 UTC +00:00')
        invoice5  = Invoice.create!(status: 1, customer_id: saundra.id, merchant_id: overstock.id, created_at: 'Thu, 14 Jan 2021 14:42:18 UTC +00:00')
        invoice6  = Invoice.create!(status: 1, customer_id: saundra.id, merchant_id: spice_emp.id, created_at: 'Sat, 16 Jan 2021 14:42:18 UTC +00:00')
        invoice7  = Invoice.create!(status: 2, customer_id: salim.id, merchant_id: amazon.id, created_at: 'Fri, 08 Dec 2020 14:42:18 UTC +00:00')
        invoice8  = Invoice.create!(status: 1, customer_id: manu.id, merchant_id: spice_emp.id, created_at: 'Sat, 16 Jan 2021 14:42:18 UTC +00:00')
        # Transactions:
        tx1       = Transaction.create!(result: "success", credit_card_number: 010001001022, credit_card_expiration_date: 20251001, invoice_id: invoice1.id,)
        tx2       = Transaction.create!(result: "success", credit_card_number: 010001005555, credit_card_expiration_date: 20220101, invoice_id: invoice1.id,)
        tx3       = Transaction.create!(result: "success", credit_card_number: 010001005551, credit_card_expiration_date: 20220101, invoice_id: invoice7.id,)
        tx4       = Transaction.create!(result: "success", credit_card_number: 010001005552, credit_card_expiration_date: 20220101, invoice_id: invoice7.id,)
        tx5       = Transaction.create!(result: "success", credit_card_number: 010001005553, credit_card_expiration_date: 20220101, invoice_id: invoice7.id,)
        tx6       = Transaction.create!(result: "success", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice2.id,)
        tx7       = Transaction.create!(result: "success", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice8.id,)
        tx8       = Transaction.create!(result: "success", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice8.id,)
        tx9       = Transaction.create!(result: "success", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice8.id,)
        tx10      = Transaction.create!(result: "failed", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice8.id,)
        tx11      = Transaction.create!(result: "failed", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice7.id,)
        tx12      = Transaction.create!(result: "failed", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice2.id,)
        tx13      = Transaction.create!(result: "failed", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice1.id,)
        tx9       = Transaction.create!(result: "success", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice3.id,)
        tx10      = Transaction.create!(result: "failed", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice3.id,)
        tx11      = Transaction.create!(result: "success", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice4.id,)
        tx12      = Transaction.create!(result: "success", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice5.id,)
        tx13      = Transaction.create!(result: "success", credit_card_number: 010001005554, credit_card_expiration_date: 20220101, invoice_id: invoice6.id,)
        # Items:
        item_1    = max.items.create!(name: 'Beans', description: 'Tasty', unit_price: 5, status: 0)
        item_2    = max.items.create!(name: 'Item 2', description: 'Blah', unit_price: 10, status: 1)
        item_3    = max.items.create!(name: 'Item 3', description: 'Test', unit_price: 15, status: 0)
        backpack  = amazon.items.create!(name: 'Camo Backpack', description: 'Double Zip Backpack', unit_price: 5.0, status: 0)
        radio     = amazon.items.create!(name: 'Retro Radio', description: 'Twist and Turn to your fav jams', unit_price: 10.0, status: 0)
        brush     = amazon.items.create!(name: 'Boar Brush', description: 'Hair Brush', unit_price: 12.5, status: 0)
        cumin     = spice_emp.items.create!(name: 'Cumin Powder', description: 'An essential spice for Indian curries and chutney', unit_price: 5.50, status: 0)
        turmeric  = spice_emp.items.create!(name: 'Turmeric Powder', description: 'A spice that comes from the turmeric plant. It is commonly used in Asian food', unit_price: 7.50, status: 0)
        paprika   = spice_emp.items.create!(name: 'Smoked Sweet Paprika', description: 'These sweet peppers are dried over an oak burning fire for a smoky flavor', unit_price: 12.5, status: 0)
        sazon     = spice_emp.items.create!(name: 'Dominican Sazon', description: 'A pre-made seasoning blend to bring out authentic Dominican flavors', unit_price: 19.0, status: 0)
        garlic    = spice_emp.items.create!(name: 'Garlic Powder', description: 'Derived from dehydrated garlic and used in cooking for flavour enhancemen', unit_price: 4.0, status: 0)
        jar       = alibaba.items.create!(name: 'Amber Glass Jar', description: 'Amber-Colored Jars', unit_price: 1.90, status: 0)
        cup       = alibaba.items.create!(name: 'Coffee Cup', description: 'Handleless Cup', unit_price: 6.5, status: 1)
        jumper    = walmart.items.create!(name: 'Black Knitted Jumper', description: 'Cable Knit Jumper', unit_price: 15, status: 0)
        earrings  = walmart.items.create!(name: 'Rose Gold Earring', description: 'Sparkly and Dangly', unit_price: 10.8, status: 0)
        sneakers  = walmart.items.create!(name: 'Running Sneakers', description: 'Trek about in these airy sneakers', unit_price: 31.0, status: 0)
        chair     = overstock.items.create!(name: 'Recliner Chair', description: 'Comfy Chair', unit_price: 24.0, status: 0)
        desk      = overstock.items.create!(name: 'Student Desk', description: 'An essential  desk for all students', unit_price: 49.5, status: 0)
        # InvoiceItems:
        invitm1   = InvoiceItem.create!(status: 0, quantity: 25, unit_price: 7.0, invoice_id: invoice1.id, item_id: item_1.id)
        invitm2   = InvoiceItem.create!(status: 2, quantity: 10, unit_price: 15.5, invoice_id: invoice2.id, item_id: item_2.id)
        invitm3   = InvoiceItem.create!(status: 0, quantity: 25, unit_price: 10, invoice_id: invoice1.id, item_id: item_2.id)
        invitm4   = InvoiceItem.create!(status: 2, quantity: 50, unit_price: 5.0, invoice_id: invoice7.id, item_id: backpack.id)
        invitm5   = InvoiceItem.create!(status: 1, quantity: 100, unit_price: 10.0, invoice_id: invoice7.id, item_id: radio.id)
        invitm6   = InvoiceItem.create!(status: 1, quantity: 20, unit_price: 10.0, invoice_id: invoice7.id, item_id: brush.id)
        invitm8   = InvoiceItem.create!(status: 2, quantity: 5, unit_price: 5.5, invoice_id: invoice8.id, item_id: cumin.id)
        invitm9   = InvoiceItem.create!(status: 0, quantity: 5, unit_price: 7.5, invoice_id: invoice8.id, item_id: turmeric.id)
        invitm10  = InvoiceItem.create!(status: 2, quantity: 10, unit_price: 12.5, invoice_id: invoice8.id, item_id: paprika.id)
        invitm11  = InvoiceItem.create!(status: 1, quantity: 12, unit_price: 19.0, invoice_id: invoice8.id, item_id: sazon.id)
        invitm12  = InvoiceItem.create!(status: 1, quantity: 15, unit_price: 4.0, invoice_id: invoice8.id, item_id: garlic.id)
        invitm13  = InvoiceItem.create!(status: 1, quantity: 100, unit_price: 1.9, invoice_id: invoice3.id, item_id: jar.id)
        invitm14  = InvoiceItem.create!(status: 1, quantity: 20, unit_price: 6.5, invoice_id: invoice3.id, item_id: cup.id)
        invitm15  = InvoiceItem.create!(status: 2, quantity: 250, unit_price: 15.0, invoice_id: invoice4.id, item_id: jumper.id)
        invitm16  = InvoiceItem.create!(status: 0, quantity: 400, unit_price: 10.8, invoice_id: invoice4.id, item_id: earrings.id)
        invitm17  = InvoiceItem.create!(status: 2, quantity: 150, unit_price: 31.5, invoice_id: invoice4.id, item_id: sneakers.id)
        invitm18  = InvoiceItem.create!(status: 1, quantity: 50, unit_price: 19.0, invoice_id: invoice5.id, item_id: chair.id)
        invitm19  = InvoiceItem.create!(status: 1, quantity: 75, unit_price: 49.5, invoice_id: invoice5.id, item_id: desk.id)
        invitm20  = InvoiceItem.create!(status: 1, quantity: 35, unit_price: 4.0, invoice_id: invoice6.id, item_id: garlic.id)
        # Discounts:
        discount_1 = Discount.create!(discount_percentage: 10, quantity_threshold: 30, merchant_id: amazon.id)
        discount_2 = Discount.create!(discount_percentage: 15, quantity_threshold: 50, merchant_id: amazon.id)
        discount_3 = Discount.create!(discount_percentage: 20, quantity_threshold: 100, merchant_id: amazon.id)
        discount_4 = Discount.create!(discount_percentage: 20, quantity_threshold: 15, merchant_id: max.id)
        discount_5 = Discount.create!(discount_percentage: 30, quantity_threshold: 15, merchant_id: max.id)
        discount_6 = Discount.create!(discount_percentage: 20, quantity_threshold: 10, merchant_id: spice_emp.id)
        discount_7 = Discount.create!(discount_percentage: 30, quantity_threshold: 15, merchant_id: spice_emp.id)
        discount_8 = Discount.create!(discount_percentage: 15, quantity_threshold: 20, merchant_id: spice_emp.id)
        discount_9 = Discount.create!(discount_percentage: 20, quantity_threshold: 15, merchant_id: alibaba.id)
        discount_10 = Discount.create!(discount_percentage: 30, quantity_threshold: 15, merchant_id: alibaba.id)
        discount_11 = Discount.create!(discount_percentage: 20, quantity_threshold: 300, merchant_id: walmart.id)
        discount_12 = Discount.create!(discount_percentage: 30, quantity_threshold: 15, merchant_id: overstock.id)
        discount_13 = Discount.create!(discount_percentage: 15, quantity_threshold: 20, merchant_id: overstock.id)
        expected = [walmart.name, overstock.name, amazon.name, spice_emp.name, max.name]
        expect(Merchant.top_five_merchants.map {|merchant| merchant.name}).to eq(expected)
      end
    end
    describe 'discount methods' do
      it "returns total revenue including applied discount" do
        expect(@all_birds.total_discount_revenue(@invoice6.invoice_items)).to eq(1140.0)
        expect(@happy_drink.total_discount_revenue(@invoice8.invoice_items)).to eq(0)
      end

      it "returns discount applied" do
        expect(@happy_cones.discount_used(@invitm8)).to eq(@discount_7)
      end
    end
  end
end
