# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    ind = 0
    my_each do |x|
      yield(x, ind)
      ind += 1
    end
  end

  def my_select
    return to_enum unless block_given?
    
    selected = []
    my_each { |i| selected << i if yield(i) }
    selected
  end

  def my_all?
    is_this_true = true
    my_each do |i|
      is_this_true = false unless yield(i)
      break unless is_this_true
    end
    is_this_true
  end

  def my_any?
    my_each do |x|
      return true if yield(x)
    end
    false
  end

  def my_none?
    its_all_false = true
    my_each do |i|
      its_all_false = false if yield(i)
      break unless its_all_false
    end
    its_all_false
  end

  def my_count(to_count)
    num = 0
    my_each { |i| num += 1 if i == to_count }
    num
  end

  def my_map(&proc)
    result = []
    if proc
      my_each { |i| result << proc.call(i) }
    else
      my_each { |i| result << yield(i) }
    end
  end

  def my_inject(field = nil, second = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    arr = to_a
    o = nil

    if field&.respond_to?(:is_a?) && field&.is_a?(Integer)
      sum = field
      d_m = 0
      if second&.respond_to?(:is_a?) && second&.is_a?(Symbol)
        o = second.to_s
        o.sub! ':', ''
      end
    else
      sum = arr[0]
      d_m = 1
    end

    if field&.respond_to?(:is_a?) && field&.is_a?(Symbol)
      o = field.to_s
      o.sub! ':', ''
    end

    (arr.length - d_m).times do |x|
      sum = o ? sum.method(o).call(arr[x + d_m]) : sum = yield(sum, arr[x + d_m])
    end
    sum
  end

  def multiply_els(arr)
    arr.my_inject { |memo, x| memo * x }
  end
end
