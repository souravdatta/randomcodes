class Generator
  attr_accessor :limit, :str_len

  def initialize(l, s_len)
    @limit = l || 1000
    @limit = @limit.to_i
    @str_len = s_len || 7
    @str_len = @str_len.to_i
  end

  def gen_num_str
    (1..@str_len).map {|x| (rand(9) + 1).to_s}.join('')
  end
  
  def generate
    map = Hash.new
    @limit.times do |t|
      s = self.gen_num_str
      while map[s]
        STDERR.puts "Duplicate found - #{s} at step #{t}"
        s = self.gen_num_str
      end
      puts(s)
    end
  end
end

Generator.new(1000, 1000).generate

