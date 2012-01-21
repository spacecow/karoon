require 'capybara' 

module Capybara
  module Node
    class Element < Base
      def div(s); find("div##{s}") end
      def li(i=0); lis[i] end

      private

        def lis; all('li') end
    end
  end
end
