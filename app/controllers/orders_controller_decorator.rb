Spree::OrdersController.class_eval do
  respond_to :html, :js

  def populate
    populator = Spree::OrderPopulator.new(current_order(true), current_currency)
    if populator.populate(params.slice(:products, :variants, :quantity))
      current_order.ensure_updated_shipments

      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')
      respond_with(@order) do |format|
        format.html { redirect_to cart_path }
        format.js {
          render :layout => false, :json => current_order.item_count
        } #
      end
    else
      flash[:error] = populator.errors.full_messages.join(" ")
      redirect_to :back
    end
  end
end