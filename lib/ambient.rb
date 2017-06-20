class Ambient

  def self.VPD(temp, rh)
    es = 0.6108 * Math.exp(17.27 * temp / (temp + 237.3))
    ea = rh / 100.0 * es
    (ea - es).abs
  end
end
