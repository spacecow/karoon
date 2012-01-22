require 'capybara' 

module Capybara
  module Node
    class Element < Base
      def div(s); find("div##{s}") end
      def li(i=0); lis[i] end
      def options(lbl)
        find_field(lbl).all(:css,"option").map{|e| e.text.blank? ? "BLANK" : e.text}.join(', ')
      end
      def selected_value(s)
        begin
          find_field(s).find(:xpath,"//option[@selected='selected']").text
        rescue
          nil 
        end
      end

      private

        def lis; all('li') end
    end
  end
end
