require "test_helper"

describe OrderItemsController do
    describe "destroy" do 
        it "can destroy order item" do 
            product = products(:yogamat)
            product_2 = products(:juice)
            post add_to_cart_path({ id: product.id, quantity: 1})
            post add_to_cart_path({ id: product_2.id, quantity: 1})

            session_id = session[:order_id]
            order = Order.find_by(id: session_id)
            order_items_count = order.order_items.length

            expect{delete order_order_item_path(order, order.order_items[0])}.must_differ "OrderItem.count", -1
            must_redirect_to cart_path
        end 
    end 

    describe 'make complete' do
        it 'will change order_item status to complete' do
            order_item = order_items(:mat_orderitem)

            expect{ patch mark_complete_path(order_item.id) }.wont_change "OrderItem.count"
            order_item.reload
            expect(order_item.status).must_equal "Completed"
        end

        it 'will respond with no found if provided an invalid id ' do
            invalid_id = -1

            expect{ patch mark_complete_path(invalid_id) }.wont_change "OrderItem.count"
            must_respond_with :not_found
        end
    end

    describe 'make cancel' do
        it 'will change order_item status to complete' do
            order_item = order_items(:mat_orderitem)

            expect{ patch mark_cancel_path(order_item.id) }.wont_change "OrderItem.count"
            order_item.reload
            expect(order_item.status).must_equal "Cancelled"
        end

        it 'will respond with no found if provided an invalid id ' do
            invalid_id = -1

            expect{ patch mark_cancel_path(invalid_id) }.wont_change "OrderItem.count"
            must_respond_with :not_found
        end
    end
end
