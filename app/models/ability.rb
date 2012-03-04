class Ability
  include CanCan::Ability

  def initialize(user)
    can [:show,:index,:who_bought], Book
    can [:show,:index], Author
    can [:show,:index], Category
    can [:show,:create], Search
    can :create, LineItem
    can :destroy, LineItem
    can [:create,:signup_confirmation], User
    if user
      can :show, User
      cannot [:create,:signup_confirmation], User
      if user.role?(User::MEMBER) || user.role?(User::VIP) || user.role?(User::MINIADMIN) || user.role?(User::ADMIN)
        can :create, Order
        can [:show,:index], Order, :user_id => user.id
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
        can [:show,:validate,:confirm,:update,:check], Order
        can [:show,:update,:destroy], Cart
        can [:index,:create,:update_multiple], Translation
        can :index, Locale
      end
      if user.role? :god
        can :manage, :all
      end 
    end #user
  end
end
