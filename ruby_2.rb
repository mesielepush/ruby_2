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
			if is_this_true == false
				break
			end
		end
		is_this_true 
  end
  
  def my_any? 
		is_this_false = false
		self.my_each {|i| is_this_false = true if yield(i)}
		is_this_false
	end
end