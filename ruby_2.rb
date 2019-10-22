module Enumerable
  def my_each
    i = 0
    while i < self.size
      yield(self[i])
      i += 1
      end
    self
  end
  
  def my_each_with_index
    i = 0
      while i < self.size
        yield(self[i], i)
        i+= 1
      end
      self
    end
  
  def my_select
    selected = []
    self.my_each { |i| selected << i if yield(i) }
    selected
  end

  def my_all? 
		is_this_true = true
		self.my_each  do |i| 
			is_this_true = false unless yield(i) 
      break unless its_all_false
      
		end
		is_this_true 
  end
  
  def my_any? 
		is_this_false = false
		self.my_each {|i| is_this_false = true if yield(i)}
		is_this_false
  end
  
  def my_none?
		its_all_false = true
		self.my_each do |i| 
			its_all_false = false if yield(i)
      break unless its_all_false
    end
		its_all_false
  end
  
  def my_count(to_count)
		num = 0
		self.my_each {|i| num += 1 if i == to_count}
	  num
  end

end