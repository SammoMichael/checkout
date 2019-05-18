class Checkout
  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @cart = Hash.new(0) # counter hash for shopping cart
    @prices = {        
      "TSHIRT" => 20.00,
      "VOUCHER" => 5.00,
      "MUG" => 7.50
    }
  end

  def scan(item)       
    @cart[item] += 1  # increment cart item by 1
    puts display_cart_and_subtotal # print readout for customer
  end

  def remove_item(item) # decrement cart item by 1 unless at 0
    return puts "There are no more of #{item}" if @cart[item] == 0 
    @cart[item] -= 1
    puts display_cart_and_subtotal
  end

  def format(currency) # format total into a 2 decimal place currency string
    return '%.2f' % currency + '€'
  end 

  def empty_cart
    @cart = Hash.new(0) # reset cart
    puts display_cart_and_subtotal
  end

  def display_cart_and_subtotal # create a readable cart display for user
    return "Cart is Empty!" if @cart.empty? || @cart.values.all?(0) # return as empty
    cart_display = ""
    @cart.each do |k, v|
      cart_display << ((k +', ') * v) # format items to comma separated string
    end
    return "Items: " + cart_display[0...-2] + "\nTotal: " + total
  end
  
  def total
    subtotal = 0
    @cart.each do |k, v| # iterate through cart and check for promotions
      if ((@pricing_rules[k]).is_a? Array) && (v >= @pricing_rules[k][0])
        subtotal += @pricing_rules[k][1] * v # bulk items checked for correct quantity
      elsif @pricing_rules[k] == "2for1" # account for even and odd sale items with modulo
        subtotal += ((v / 2) * @prices[k]) + ((v % 2) * @prices[k])
      # elsif @pricing_rules[k].index("%") # account for % discounts
      #   subtotal += v * (@prices[k] * (1 - (@pricing_rules[k].to_f/100)))
      else
        subtotal += v * @prices[k] # default price
      end
    end
    return format(subtotal) 
  end  

end 

pricing_rules = {
"VOUCHER" => "2for1",
"TSHIRT" => [3, 19.00],
"MUG" => "15%"
}

# Tests
co = Checkout.new(pricing_rules)
co.scan('VOUCHER')
co.scan('TSHIRT')
co.scan('MUG')
price = co.total
puts price + " should equal 32.50€"
puts
co.empty_cart
co.scan('VOUCHER')
co.scan('TSHIRT')
co.scan('VOUCHER')
price = co.total
puts price + " should equal 25.00€"
puts
co.empty_cart
co.scan('TSHIRT')
co.scan('TSHIRT')
co.scan('TSHIRT')
co.scan('VOUCHER')
co.scan('TSHIRT')
price = co.total
puts price + " should equal 81.00€"
puts
co.empty_cart
co.scan('VOUCHER')
co.scan('TSHIRT')
co.scan('VOUCHER')
co.scan('VOUCHER')
co.scan('MUG')
co.scan('TSHIRT')
co.scan('TSHIRT')
price = co.total
p price + " should equal 74.50€"
puts
co.remove_item('TSHIRT')
co.remove_item('TSHIRT')
co.remove_item('TSHIRT')
co.remove_item('TSHIRT')
co.remove_item('VOUCHER')
co.remove_item('VOUCHER')
co.remove_item('VOUCHER')
co.remove_item('MUG')
co.remove_item('MUG')
co.remove_item('MUG')
co.remove_item('MUG')
price = co.total
# p price + " should equal " + co.empty_cart.total
puts co.empty_cart

# Items: VOUCHER, TSHIRT, MUG
# Total: 32.50€

# Items: VOUCHER, TSHIRT, VOUCHER
# Total: 25.00€

# Items: TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT
# Total: 81.00€

# Items: VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT
# Total: 74.50€