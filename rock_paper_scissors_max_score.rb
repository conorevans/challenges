def solution(input_string)
  gestures = split_into_chars(input_string)
  counts = counts_hash(gestures)
  max_total(counts)
end

private 

# split the string into array of length-one substrings
# assumption that string contains letters R,P,S
# nothing mentioned about case so make sure all upcase
def split_into_chars(input_string)
  input_string.upcase.split('')
end

# get counts of each gesture in input string of gestures
# in hash form
def counts_hash(gestures)
  counts = { 'R' => 0, 'S' => 0, 'P' => 0 }
  
  gestures.each do |gesture|
    counts[gesture] = counts[gesture] + 1
  end
  
  counts
end

# get max total possible by playing any individual gesture on each occasion
def max_total(counts)
  [rock_points(counts), scissor_points(counts), paper_points(counts)].max
end

# get max total possible by playing using only rock
def rock_points(counts)
  counts['R'] + (counts['S'] * 2)
end

# get max total possible by playing using only scissors
def scissor_points(counts)
  counts['S'] + (counts['P'] * 2)
end

# get max total possible by playing using only paper
def paper_points(counts)
  counts['P'] + (counts['R'] * 2)
end
