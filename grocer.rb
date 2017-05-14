require 'pry'

def consolidate_cart(cart)
  cart_hash = {}

  cart.each do |item|
    item.each do |name, value|
      if !cart_hash[name]
        cart_hash[name] = value
        cart_hash[name][:count] = 0
      end
      cart_hash[name][:count] += 1
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, prop|
    if prop[:clearance]
      new_price = prop[:price]*0.80
      prop[:price] = new_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  cart_after_coupon = apply_coupons(consolidated_cart,coupons)
  cart_clearance = apply_clearance(cart_after_coupon)

  final_cost = 0

  cart_clearance.each do |item, prop|
    final_cost += prop[:price] * prop[:count]
  end

  if final_cost > 100
    final_cost = final_cost*0.90.round(2)
  end

  final_cost

end
