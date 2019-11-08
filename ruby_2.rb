# frozen_string_literal: true

module Enumerable # rubocop:disable Metrics/ModuleLength
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

  def my_all?(field = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    value = true
    length.times do |x|
      if !field.nil?
        if field.instance_of? Regexp
          value = false unless self[x].match(field)
        elsif field.respond_to?(:is_a?) && (field.is_a?(String) || field.is_a?(Integer))
          value = false if field != self[x]
        elsif field.respond_to?(:is_a?) && !(self[x].is_a? field)
          value = false
        end
      elsif block_given?
        value = false unless yield(self[x])
      else
        value = false unless self[x]
      end
    end
    value
  end

  def my_any?(field = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    value = false
    length.times do |x|
      if !field.nil?
        if field.instance_of? Regexp
          value = true if self[x].match(field)
        elsif field.respond_to?(:is_a?) && (field.is_a?(String) || field.is_a?(Integer))
          value = true if field == self[x]
        elsif field.respond_to?(:is_a?) && (self[x].is_a? field)
          value = true
        end
      elsif block_given?
        value = true if yield(self[x])
      elsif self[x]
        value = true
      end
    end
    value
  end

  def my_none?(field = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    length.times do |x|
      if !field.nil?
        if field.instance_of? Regexp
          return false if self[x].match(field)
        elsif field.respond_to?(:is_a?) && (field.is_a?(String) || field.is_a?(Integer))
          return false if field == self[x]
        elsif field.respond_to?(:is_a?) && (self[x].is_a? field)
          return false
        end
      elsif block_given?
        return false if yield(self[x])
      elsif self[x]
        return false
      end
    end
    true
  end

  def my_count(field = nil)
    return length if !block_given? && !field

    item = 0
    length.times do |x|
      if field
        item += 1 if field == self[x]
      elsif yield(self[x])
        item += 1
      end
    end
    item
  end

  def my_map(my_proc = false)
    return to_enum unless block_given?

    item = []
    length.times do |x|
      result = my_proc ? my_proc.call(self[x]) : yield(self[x])
      item.push(result)
    end
    item
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
