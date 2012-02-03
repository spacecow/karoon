class Ability
  include CanCan::Ability

  def initialize(user)
    can [:show,:index,:who_bought], Book
    can [:show,:index], Author
    can [:show,:index], Category
    can [:show,:create], Search
    can :create, LineItem
    can :destroy, LineItem
    if user
      if user.role?(User::MEMBER) || user.role?(User::VIP) || user.role?(User::MINIADMIN) || user.role?(User::ADMIN)
        can :create, Order
        can :show, Order, :user_id => user.id
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
        can :update, Setting
        can :index, Search
        can :create, LineItem
        can [:show,:validate,:confirm,:update], Order
        can [:show,:update,:destroy], Cart
        can [:index,:create,:update_multiple], Translation
        can :index, Locale
      end
      if user.role? :god
        can :manage, :all
      end 
    end
  end
end
