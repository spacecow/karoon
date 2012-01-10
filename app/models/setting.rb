class Setting < ActiveRecord::Base
  RIEL = "Riel"
  TOMAN = "Toman"
  CURRENCY = [RIEL, TOMAN]

  class << self
    def currency_in_riel?;
      singleton.currency == RIEL
    end
    def in_currency; "in #{singleton.currency}" end 
    def singleton; Setting.first end
  end
end
