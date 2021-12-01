def valid_input(input)
  return false if /^[[NKQRB][a-h]]x?[[a-h][1-8]][a-h][1-8]$/.match(input)
  Object.const_get(piece(input)).valid_move(input, color, @board)
end

loop do
  input = gets.chomp
  break if valid_input(input)
end