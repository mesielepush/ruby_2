# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    while i < size
      yield([i])
      i += 1
    end
    self
  end

  def my_each_with_index
    i = 0
    while i < size
      yield([i], i)
      i += 1
    end
    self
  end

  def my_select
    selected = []
    my_each { |i| selected << i if yield(i) }
    selected
  end
  
  def my_all? 
    is_this_true = true
    my_each  do |i|
      is_this_true = false unless yield(i) 
      break unless its_all_false
    end
    is_this_true
  end
  
  def my_any?
    is_this_false = false
    my_each do |i|
      is_this_false = true if yield(i)
    is_this_false
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
		my_each {|i| num += 1 if i == to_count}
	  num
  end
  
  def my_map(&proc)
		result = []
		if proc
			my_each {|i| result << proc.call(i)}
			result
		else
			my_each {|i| result << yield(i)}
			result
		end
	end
  
  def my_inject(obj=nil)
    yielding = obj ? obj : shift
   
    my_each do |x|
      yielding = yield(yielding, x)
    end
   
    yielding
  end

  def multiply_els(arr)
    arr.my_inject { |memo, x| memo * x }
  end

end