require 'rails_helper'

describe 'As a merchant' do
  describe "When I visit my merchant items index page ('merchant/merchant_id/items')" do
    before :each do
      @max = Merchant.create!(name: 'Merch Max')
      @bob = Merchant.create!(name: 'Bob')
      @item_1 = @max.items.create!(name: 'Beans', description: 'Tasty', unit_price: 5, status: 0)
      @item_2 = @max.items.create!(name: 'Item 2', description: 'Blah', unit_price: 10, status: 0)
      @item_3 = @bob.items.create!(name: 'Item 3', description: 'Test', unit_price: 15, status: 0)

      visit "merchants/#{@max.id}/items"
    end

    it 'I see a list of the names of all of my items' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)
    end

    it 'I do not see items for any other merchant' do
      expect(page).to_not have_content(@item_3.name)
    end

    describe 'When I click on the name of an item' do
      it "Then I am taken to that merchant's item's show page (/merchant/merchant_id/items/item_id)" do
        expect(page).to have_link(@item_1.name, href: "/merchants/#{@max.id}/items/#{@item_1.id}")
        expect(page).to have_link(@item_2.name, href: "/merchants/#{@max.id}/items/#{@item_2.id}")

        click_link(@item_1.name)

        expect(current_path).to eq("/merchants/#{@max.id}/items/#{@item_1.id}")
      end
    end

    it 'Next to each item name I see a button to disable or enable that item' do
      expect(page).to have_selector("input[id='disable-merchant-item-#{@item_1.id}-btn']")
      expect(page).to have_selector("input[id='disable-merchant-item-#{@item_2.id}-btn']")
    end

    describe 'When I click this button' do
      before :each do
        within ".merchant-item-#{@item_1.id}" do
          click_on 'Disable'
        end
      end

      it 'Then I am redirected back to the items index' do
        expect(current_path).to eq(merchant_items_path(@max.id))
      end

      it 'Then I see that the items status has changed' do
        within ".merchant-item-#{@item_1.id}" do
          expect(page).to have_content("Status: Disabled")
          expect(page).to have_button("Enable")

          click_on 'Enable'

          expect(page).to have_content("Status: Enabled")
          expect(page).to have_button("Disable")
        end
      end
    end

    it "Then I see two sections, one for 'Enabled Items' and one for 'Disabled Items'" do
      expect(page).to have_selector("section[id='enabled-merchant-items']")
      expect(page).to have_content("Enabled Merchant Items")
      expect(page).to have_selector("section[id='disabled-merchant-items']")
      expect(page).to have_content("Disabled Merchant Items")
    end

    it 'Then I see that each Item is listed in the appropriate section based on status' do
      item_4 = @max.items.create!(name: 'Item 4', description: 'Item 4 Description...', unit_price: 20, status: 1)
      item_5 = @max.items.create!(name: 'Item 5', description: 'Item 5 Description...', unit_price: 30, status: 1)

      visit merchant_items_path(@max.id)

      within '#enabled-merchant-items' do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_2.name)
      end

      within '#disabled-merchant-items' do
        expect(page).to have_content(item_4.name)
        expect(page).to have_content(item_5.name)
      end
    end

    it "can see a link to create a new item" do
      visit merchant_items_path(@max.id)

      click_link "Create New Item"

      expect(current_path).to eq("/merchants/#{@max.id}/items/new")
    end

    it 'Then I see the names of the top 5 most popular items ranked by total revenue generated' do
      item_4 = @max.items.create!(name: 'Item 4', description: 'Item 4 description', unit_price: 15, status: 0)
      item_5 = @max.items.create!(name: 'Item 5', description: 'Item 5 description', unit_price: 20, status: 0)
      item_6 = @max.items.create!(name: 'Item 6', description: 'Item 6 description', unit_price: 25, status: 0)
      item_7 = @max.items.create!(name: 'Item 7', description: 'Item 7 description', unit_price: 30, status: 0)
      item_8 = @max.items.create!(name: 'Item 8', description: 'Item 8 description', unit_price: 35, status: 0)
      item_9 = @max.items.create!(name: 'Item 9', description: 'Item 9 description', unit_price: 40, status: 0)

      sally    = Customer.create!(first_name: 'Sally', last_name: 'Smith')

      invoice_1 = sally.invoices.create!(status: 1, merchant_id: @max.id)

      invitm_1  = invoice_1.invoice_items.create!(status: 0, quantity: 1, unit_price: 5, item_id: item_4.id)
      invitm_2  = invoice_1.invoice_items.create!(status: 2, quantity: 1, unit_price: 10, item_id: item_5.id)
      invitm_3  = invoice_1.invoice_items.create!(status: 1, quantity: 1, unit_price: 15, item_id: item_6.id)
      invitm_4  = invoice_1.invoice_items.create!(status: 1, quantity: 1, unit_price: 20, item_id: item_7.id)
      invitm_5  = invoice_1.invoice_items.create!(status: 1, quantity: 1, unit_price: 25, item_id: item_8.id)
      invitm_6  = invoice_1.invoice_items.create!(status: 1, quantity: 1, unit_price: 30, item_id: item_9.id)

      visit merchant_items_path(@max.id)

      within 'top-5-most-popular-items' do
        expect(item_9.name).to appear_before(item_8.name)
        expect(item_8.name).to appear_before(item_7.name)
        expect(item_7.name).to appear_before(item_6.name)
        expect(item_6.name).to appear_before(item_5.name)
        expect(page).to_not have_content(item_4.name)
      end
    end
  end
end

# Then I see the names of the top 5 most popular items ranked by total revenue generated
# And I see that each item name links to my merchant item show page for that item
# And I see the total revenue generated next to each item name
#
# Notes on Revenue Calculation:
# - Only invoices with at least one successful transaction should count towards revenue
# - Revenue for an invoice should be calculated as the sum of the revenue of all invoice items
# - Revenue for an invoice item should be calculated as the invoice item unit price multiplied by the quantity (do not use the item unit price)
