require 'Set'

class Checkout
  attr_reader :prices, :basket, :offers
  private :prices, :basket, :offers

  def initialize(prices:)
    @prices = prices
    @offers = Hash.new
    @basket = Hash.new
    set_offers
  end

  def scan(item:)
    return add_to_basket(item: item.to_sym) unless basket.key?(item.to_sym)

    basket[item.to_sym] += 1
  end

  def total
    validate_basket!
    total = 0

    basket.each do |item, purchase_count|
      price = prices[item]
      if offers.key?(item)
        discounted_item_count = (purchase_count / offers[item][:discounted_item_at]).floor
        discount_rate = offers[item][:discount_rate]
        limit = offers[item][:limit_per_customer] || 'N/A'

        final_discounted_item_count = [limit, discounted_item_count].keep_if { |value| value.is_a?(Integer) }.min
        total += (price * purchase_count) - (final_discounted_item_count * price * discount_rate).to_i
      else
        total += price * purchase_count
      end
    end
    total
  end

  private

  def validate_basket!
    products_with_price = prices.keys.to_set
    products_in_basket = basket.keys.to_set

    raise('Invalid product - no information on record') unless products_in_basket.subset?(products_with_price)
  end

  # initialize count for new items
  def add_to_basket(item:)
    @basket[item.to_sym] = 1
  end

  def set_offers
    %i[apple pear].each do |item|
      create_offer(item: item, discounted_item_at: 2)
    end

    create_offer(item: 'banana', discounted_item_at: 1, discount_rate: 0.5)
    create_offer(item: 'pineapple', discounted_item_at: 2, discount_rate: 0.5, limit_per_customer: 1)
    create_offer(item: 'mango', discounted_item_at: 4)
  end

  # discounted_item_at = at which item does the discount kick in (1 = at first (BOGOHP), 2 = at second (BOGOF))
  def create_offer(item:, discounted_item_at:, discount_rate: 1, limit_per_customer: nil)
    offers[item.to_sym] = { 'discounted_item_at': discounted_item_at,
                            'discount_rate': discount_rate,
                            'limit_per_customer': limit_per_customer
                          } 
  end
end
