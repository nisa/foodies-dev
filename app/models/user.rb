class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_many :authorizations, :dependent => :destroy
  
  validates :name,  :presence => true
  validates :email, :presence => true, :uniqueness => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }
  acts_as_authentic do |c|
  	c.login_field = :email          # email is the login field
    c.validate_login_field = false
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver
  end
  def deliver_verification_instructions!
    reset_perishable_token!
    Notifier.verification_instructions(self).deliver
  end
  def verify!
      self.verified = true
      self.save
  end

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email']
    # Update user info fetching from social network
    case omniauth['provider']

    when 'facebook'
      self.name = omniauth['info']['name']
      self.verified = 1
      self.crypted_password = 'facebook'
      self.password_salt = 'facebook'
      self.persistence_token = 'facebook' 

    when 'google_oauth2'
      self.name = omniauth['info']['name']
      self.verified = 1
      self.crypted_password = 'google'
      self.password_salt = 'google'
      self.persistence_token = 'google' 
    end  
  end

  
end
