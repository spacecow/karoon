class Ability
  include CanCan::Ability

  def initialize(user)
    can [:show,:index], Book
    can [:show,:index], Author
    can [:show,:index], Category
    can [:show,:create], Search
    can :create, LineItem
    can [:update,:destroy], Cart
    if user
      if user.role?(User::MEMBER) || user.role?(User::VIP) || user.role?(User::MINIADMIN) || user.role?(User::ADMIN)
        can :create, Order
      end
      if user.role? :admin
        can [:create,:update,:destroy,:create_individual], Book
        can [:create,:update,:destroy], Author
        can [:create,:update,:destroy], Category
        can [:update], Setting
        can :index, Search
        can :create, LineItem
      end
      if user.role? :god
        can :manage, :all
      end 
    end
  end
end
