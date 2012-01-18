require 'capybara' 

module Capybara
  module Node
    class Element < Base
      def div(s); find("div##{s}") end
    end
  end
end
