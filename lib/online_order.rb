require_relative "./order.rb"
include Grocery


ONLINE_FILE_NAME = "../support/online_orders.csv"

class OnlineOrder < Grocery::Order
  attr_accessor :status, :products
  attr_reader :customer_id, :id
  def initialize(id,customer_id,status = :pending,products)
    @customer_id = customer_id
    @status = status
    @products = products
    @id = id
    @tax = 0.075
  end

  def total
    # shipping_fee = 10.00
    # super + shipping_fee
    shipping_fee = 10.00
    total = super
    if total != 0
      total += shipping_fee
    end
    return total.round(2)
  end


  def add_product(product_name, product_price)
    unless self.status == :pending || self.status == :paid
      raise ArgumentError.new("You can only add products to orders with a status of 'Pending' or 'Paid'")
    end
    super
  end

  def self.all
    all_online_orders = []

    CSV.open(ONLINE_FILE_NAME, "r").each do |line|

      id = line[0].to_i
      status = line[-1].to_sym
      customer_id = line[-2].to_i
      products = {}
      product_array = line[1].split(";")
      product_array.each do |item|
        split_item = item.split(":")
        product_name = split_item[0]
        product_price = split_item[1].to_f
        products[product_name] = product_price
      end
      all_online_orders << self.new(id,customer_id,status,products)
    end
    return all_online_orders
  end

  def self.find(id)
    self.all.each do |online_order|
      return online_order if online_order.id == id
    end
    raise ArgumentError.new("This order ID was not found")
  end

  def self.find_by_customer(customer_id)
    customer_orders = []
    self.all.each do |online_order|
      if online_order.customer_id == customer_id
        customer_orders << online_order
      end
    end
    return customer_orders
  end

end
