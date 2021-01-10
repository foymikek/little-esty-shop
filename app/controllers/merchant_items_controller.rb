class MerchantItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    @merchant_items = merchant.items
  end

  def show
    merchant = Merchant.find(params[:merchant_id])
    @merchant_items = merchant.items
  end
end
