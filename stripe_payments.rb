#!/bin/ruby

require 'json'
require 'stringio'



def calculate_total_owed(actions)
    @payments = {}
    @received_payments = []
    @owed = 0

    actions.length.times do |i|
        # payment actions don't contain a currency amount
        # skip if non pay-action and is not a dollar amount
        next if !actions[i].match?(/USD/) && !actions[i].match?(/PAY/)

        # search string for id, status, and amount
        id = id(actions[i])
        # since all treatment of payments is kept within a conditional
        # regarding status and .downcase is called, we don't want it to be nil
        # as nil.downcase will throw an error
        status = status(actions[i]).downcase
        amount = amount(actions[i])

        if status == 'create' 
            if @received_payments.include?(id)
                puts 'You tried to finalize an invoice that was already paid'
                puts "Invoice number #{id}"
            elsif @payments.key?(id)
                puts 'You tried to create an invoice that had already been created or finalized.'
                puts "Invoice number #{id}"
            else
                @payments[id] = { status => amount }
            end
        elsif status == 'finalize'
            if @received_payments.include?(id)
                puts 'You tried to finalize an invoice that was already paid'
                puts "Invoice number #{id}"
            elsif !@payments.key?(id) || @payments[id].keys.first.downcase == 'finalize'
                puts 'You tried to finalize an invoice that had not yet been created or had already been finalized.'
                puts "Invoice number #{id}"
            else
                @payments[id] = { status => amount }
            end
        elsif status == 'pay'
            if @payments[id].nil?
                puts 'You tried to pay an invoice that had not yet been created nor finalized.'
                puts "Invoice number #{id}"
            elsif @received_payments.include?(id)
                puts 'You tried to pay an invoice that was already paid'
                puts "Invoice number #{id}"
            else
                @received_payments << id
            end
        end
    end

    @payments.each do |id, values|
        next if @received_payments.include?(id)

        dollar_amount = values.values.first.to_i
        @owed += dollar_amount
    end

    @owed
end

# these string search functions using regex assume that the string passed is pretty airtight
# format-wise. if there were no verification taking place beforehand,
# verification would have to take place here.
def id(action)
    id_param = action[/id=\d+/]
    id_param[/\d+/]
end

def status(action)
    status_param = action.split(/\:\s+id/)
    return 'INVALID' if status_param.nil?

    status_param[0]
end

def amount(action)
    amount_param = action[/amount\=\d+/]
    return if amount_param.nil?

    amount_param[/\d+/]
end

fptr = File.open(ENV['OUTPUT_PATH'], 'w')

# I would look into potentially treating PAY actions 'at the source'. In my submission, I run through all the payments 
# and skip any who figure in the @received_payments array. To not do so would save many .include? calls (searching through a lengthy array might be expensive). 
# However, in order to do that, we would have to keep a running total of the amount owed (given the permutations, this could be more complex 
# i.e: create => + create_amount, finalize => + (create_amount - amount_in_finalize_action), paid => - paid_amount.
# We would have to keep in mind however that someone could try to create or finalize using an ID for a payment that had already been PAID 
# and so we would maybe have to keep an extra datapoint within the hash which would be messy. Another benefit of keeping all transactions in a hash 
# and indexing our PAID transactions using an array is that the hash would represent the entire data of a transaction (in database terms). 
# Such an input of payments may already have a unique transaction identifier, but if they didn't, it would be a good way to know the entirety of the data the transaction contained.
