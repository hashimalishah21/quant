# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  name                   :string(255)
#  height                 :float
#  time_zone              :string(255)      default("UTC")
#

class User < ActiveRecord::Base
  include Users::Meals
  include Users::Weights
  include Users::Moods
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:withings, :fitbit]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email,
    :password,
    :password_confirmation,
    :remember_me,
    :name,
    :height,
    :time_zone

  validates_numericality_of :height, allow_nil: true
  validates_presence_of :name

  after_save :update_weights_bmi, if: :height_changed?

  has_many :weights
  has_many :places
  has_many :meals
  has_many :moods
  has_many :sleeps

  has_one :withings_account
  has_one :fitbit_account

  def sync_all_provider_data
    [withings_account, fitbit_account].each {|provider|
      begin
        provider.try(:get_user_data)
      rescue
        raise Exceptions::ApiError
      end
    }
  end

  # This method exists to address a shortcoming in cancan where you can't define particular
  # ability blocks as having exceptions when using :all
  def user_id
    @user_id ||= self.id
  end
end
