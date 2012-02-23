class Setting < ActiveRecord::Base
  RIAL = "rial"
  TOMAN = "toman"
  CURRENCY = [RIAL, TOMAN]

  class << self
    def currencies; CURRENCY.map{|e| I18n.t(e)} end
    def in_currency; I18n.t("in_#{singleton.currency}") end 
    def singleton; Setting.first end
  end
end
