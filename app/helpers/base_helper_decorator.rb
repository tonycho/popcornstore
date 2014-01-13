module Spree
  module BaseHelper
    def link_to_cart(text = nil)
      return "" if current_spree_page?(spree.cart_path)

      text = text ? h(text) : Spree.t('cart')
      css_class = nil

      if current_order.nil? or current_order.item_count.zero?
        text = ""
        css_class = ''
      else
        text = "Checkout (#{current_order.item_count})".html_safe
        css_class = 'full'
      end

      link_to text, spree.cart_path, :class => "#{css_class}"
    end
  end
end
