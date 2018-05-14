require "pry"
def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |item|
    item.each do |fruit, price_and_clearance|
      consolidated_cart[fruit] ||= price_and_clearance
      consolidated_cart[fruit][:count] ||= 0
      consolidated_cart[fruit][:count] +=1
    end
  end
  return consolidated_cart
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
  cart.each do |fruit, price_clearance_count|
    if cart[fruit][:clearance] == true
      cart[fruit][:price] = (cart[fruit][:price]*0.80).round(3)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  final_cart.each do |fruit, price_clearance_count|
    total += price_clearance_count[:price] * price_clearance_count[:count]
  end
  total = total * 0.9 if total > 100
  total
end
