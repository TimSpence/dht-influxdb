class Ambient

  def self.VPD(temp, rh)
    es = 0.6108 * Math.exp(17.27 * temp / (temp + 237.3))
    ea = rh / 100.0 * es
    (ea - es).abs
  end

  def self.is_valid_temp?(temp)
    temp > -7.0 && temp < 51
  end

  def self.is_valid_rh?(rh)
    rh > 10.0 && rh < 95.0
  end
end
