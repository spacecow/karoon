class Ability
  include CanCan::Ability

  def initialize(user)
    can [:show,:index,:who_bought], Book
    can [:show,:index], Author
    can [:show,:index], Category
    can [:show,:create], Search
    can :create, LineItem
    can [:update,:destroy], Cart
    if user
      if user.role?(User::MEMBER) || user.role?(User::VIP) || user.role?(User::MINIADMIN) || user.role?(User::ADMIN)
        can :create, Order
        can [:validate,:confirm,:update], Order, :user_id => user.id, :aasm_state => "draft"
      end
      if user.role?(User::VIP) || user.role?(User::MINIADMIN) || user.role?(User::ADMIN)
      end
      if user.role?(User::MINIADMIN) || user.role?(User::ADMIN)
      end
      if user.role? :admin
        can [:create,:update,:destroy,:create_individual], Book
        can [:create,:update,:destroy], Author
        can [:create,:update,:destroy], Category
        can [:update], Setting
        can :index, Search
        can :create, LineItem
        can [:validate,:confirm,:update], Order
      end
      if user.role? :god
        can :manage, :all
      end 
    end
  end
end
