# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    
      user ||= User.new # guest user (not logged in)
      can_admin(user)
      can_creator(user)
      can_user(user)
      can_else(user)
      

      
    
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    # :index , :show, :to => :read  
    # :create, :new , :to => :create
    # :update, :edit, :to => :update
  end

  private

  def can_admin(user)
    if user.admin?
      can :manage, :all
    end
  end

  def can_creator(user)
    if user.creator?
      can [:create, :read, :top], :all
      can [:update, :delete], Event, creator_id: user.id
      can :rsvp_create, Event
      cannot :index, User
    end
  end

  def can_user(user)
    if user.user?
      can [:read, :top], :all
      can :rsvp_create, Event
      cannot :index, User
    end
  end

  def can_else(user)
    if !user.admin? && !user.creator? && !user.user?
      can [:read, :top], :all
      can :create, User
      cannot :index, User
    end
  end
end
