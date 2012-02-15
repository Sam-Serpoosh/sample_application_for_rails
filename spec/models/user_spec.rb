require 'spec_helper'

describe User do

		before do
				@attr = {:name => "Example User", :email => "user@example.com"}
		end

		it "should create a new instance given valid attributes" do
				User.create!(@attr)
		end

		it "should require a name" do
				no_name_user = User.new(@attr.merge(:name => ""))
				no_name_user.should_not be_valid
		end

		it "should require an email" do
				no_email_user = User.new(@attr.merge(:email => ""))
				no_email_user.should_not be_valid
		end

		it "should reject names that are too long" do
				long_name = "a" * 51
				long_name_user = User.new(@attr.merge(:name => long_name))
				long_name_user.should_not be_valid
		end

		it "should accept valid email addresses" do
				addresses = %w[user@foo.com THE_USER@foo.bar.org fist.last@foo.jp]
				addresses.each do |address|
						valid_email_user = User.new(@attr.merge(:email => address))
						valid_email_user.should be_valid
				end
		end

		it "should reject invalid email addresses" do
				addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
				addresses.each do |address|
						invalid_email_user = User.new(@attr.merge(:email => address))
						invalid_email_user.should_not be_valid
				end
		end

		it "should reject duplicate email addresses" do
				User.create!(@attr)
				duplicate_email_user = User.new(@attr)
				duplicate_email_user.should_not be_valid
		end

		it "should reject duplicate email address and ignore the case" do
				User.create!(@attr)
				upper_case_email = @attr[:email].upcase
				upper_case_email_user = User.new(@attr.merge(:email => upper_case_email))
				upper_case_email_user.should_not be_valid
		end

end
