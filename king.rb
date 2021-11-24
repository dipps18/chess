class King
  attr_accessor :pos, :sym
  def initialize(color, sym)
		@sym = sym
		@pos = color == 'black' ? [0, 4] : [7, 4]
		@moves = nil
	end
 
end