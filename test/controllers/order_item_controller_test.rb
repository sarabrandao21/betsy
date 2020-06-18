require "test_helper"

describe OrderItemsController do
    describe "destroy" do 
        it "can destroy order item" do 
            order = orders(:nataliyas_order)
            order_item = order_items(:gear_orderitem)
            expect{delete order_order_item_path(order, order_item)}.must_differ "OrderItem.count", -1
            must_redirect_to cart_path
        end 
    end 
end
