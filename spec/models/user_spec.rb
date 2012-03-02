require 'spec_helper'

describe User do

		before do
				@attr = {:name => "Example User", :email => "user@example.com",
						:password => "foobar", :password_confirmation => "foobar"}
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

		describe "Password Validations" do
				it "should require a password" do
						without_password_user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
						without_password_user.should_not be_valid
				end

				it "should require matching password confirmation" do
						not_matched_password_user = User.new(@attr.merge(:password_confirmation => "invalid"))
						not_matched_password_user.should_not be_valid
				end

				it "should reject short password" do
						short_password = "a" * 5
						short_password_user = User.new(@attr.merge(:password => short_password, :password_confirmation => short_password))
						short_password_user.should_not be_valid
				end

				it "should reject long passwords" do
						long_password = "a" * 41
						long_password_user = User.new(@attr.merge(:password => long_password, :password_confirmation => long_password))
						long_password_user.should_not be_valid
				end
		end

		describe "Password Encryption" do
				before do
						@user = User.create!(@attr)
				end

				it "should have an encrypted password attribute" do
						@user.should respond_to(:encrypted_password)
				end

				it "should set the encrypted password" do
						@user.encrypted_password.should_not be_blank
				end

				describe "has_password? method" do
					it "should be true if the passwords match" do
							@user.has_password?(@attr[:password]).should be_true
					end

					it "should be false if the passwords dont match" do
							@user.has_password?("invalid").should be_false
					end
				end

				describe "authenticate method" do
						it "should return nil on email/password mismatch" do
								wrong_password_user = User.authenticate(@attr[:email], "wrongpassword")
								wrong_password_user.should be_nil
						end

						it "should return nil for an email address with no user" do
								nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
								nonexistent_user.should be_nil
						end

						it "should return the user on email/password match" do
								matching_user = User.authenticate(@attr[:email], @attr[:password])
								matching_user.should == @user
						end
				end
		end

		describe "admin attribute" do

				before do
						@user = User.create!(@attr)
				end

				it "should respond to admin" do
						@user.should respond_to(:admin)
				end

				it "should not be an admin by default" do
						@user.should_not be_admin
				end

				it "should be convertable to admin" do
						@user.toggle!(:admin)
						@user.should be_admin
				end

		end

end
