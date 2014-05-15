class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :recoverable, :lockable,
         :trackable, :confirmable, :token_authenticatable

  has_many :releases

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Custom validation
  validate :validate_email

  def validate_email
    unless email.blank?
      emailarray = email.split('@')[1].split('.')
      emaildomain = emailarray[emailarray.length - 2] + '.' +  emailarray[emailarray.length - 1]
      errors.add(:email, 'is not valid.') if emaildomain.downcase != 'sage.com'
    end
  end
end
