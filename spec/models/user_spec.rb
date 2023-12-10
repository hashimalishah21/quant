# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
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
#  height                 :decimal(, )
#

require 'spec_helper'

describe User do
  it { should have_many(:measurements) }
  it { should have_many(:weights) }
  let(:user) { Fabricate(:user) }

  describe "#weight" do
    before(:each) do
      2.times do
        user.weights.create(recorded_at: Time.now, value: 1.0)
      end
    end

    it "returns the last recorded Weight" do
      binding.pry
      user.weight.should eq(user.weights.order("recorded_at DESC").first)
    end

    it "returns the same value as #current" do
      user.weight.should eq(user.weights.current)
    end
  end
end
