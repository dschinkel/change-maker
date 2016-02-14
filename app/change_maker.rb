
class ChangeMaker
  # Returns an array of the least amount of coins required to get to 'amount'
  # **Assumption** Change can always be made - BONUS POINTS - raise an error if
  # change can not be made
  # Params:
  # +amount+:: The amount to make change for
  # +denominations+:: An array containing the denominations that can be used.
  #                   Defaults to standard US coin denominations
  def self.make_change(amount, denominations=[1,5,10,25])
    denomination_subset = denominations.find_all{|d| d < amount}
    combinations = find_combinations(amount, denomination_subset.sort)

    if amount_exists_in_denominations(amount, denominations)
      return [amount]
    end

    if combinations == []
      combinations = find_combinations(amount, denomination_subset.reverse!)
    end

    return combinations != [] ? combinations : raise(ChangeError)
  endgit


  def self.find_combinations(amount, denominations)
    onlyOneDenomination = denominations.count == 1
    remainder = amount
    change = []


    if onlyOneDenomination
      numberOfDuplicationsNeeded = amount / denominations[0]

      i = 0
      change = []

      while i < numberOfDuplicationsNeeded
        change.push(denominations[0])
        i += 1
      end

      return change
    end

    denominations.each do |d|
      if remainder >= 0 && remainder >= d && remainder - d >= 0
        change.push(d)
        remainder = remainder - d
      end
    end

    self.add_remainder(remainder, change, denominations)

    return change.inject(0){|sum,x| sum + x } == amount ? change : []

  end

  def self.add_remainder(remainder, change, denominations)
    if remainder > 0
      if denominations.include?(remainder)
        change.push(remainder)
      end
    end
  end

  def self.amount_exists_in_denominations(amount, denominations)
    denominations.include?(amount)
  end
end

class ChangeError < StandardError; end