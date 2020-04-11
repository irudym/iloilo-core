module PinGenerator
  def pin (length = 6)
    o = [('A'..'Z'), (0..9)].map(&:to_a).flatten
    (0...length).map { o[rand(o.length)] }.join
  end
end