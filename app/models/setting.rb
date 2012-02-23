class Setting < ActiveRecord::Base
  RIAL = "rial"
  TOMAN = "toman"
  CURRENCY = [RIAL, TOMAN]

  class << self
    #def currency_in_riel?;
    #  singleton.currency == RIEL
    #end
    #def currency_in_toman?;
    #  singleton.currency == TOMAN 
    #end
    def in_currency; I18n.t("in_#{singleton.currency}") end 
    def singleton; Setting.first end
  end
end
