class Setting < ActiveRecord::Base
  RIEL = "Riel"
  TOMAN = "Toman"
  CURRENCY = [RIEL, TOMAN]

  class << self
    def singleton; Setting.first end
  end
end
