require 'spec_helper'

describe UsersController do

		render_views

		describe "GET 'new'" do

				it "should be successful" do
						get :new
						response.should be_success
				end

				it "should have the right title" do
						get :new
						response.should have_selector('title', :content => "Sign up")
				end

				it "should have name field" do
						get :new
						response.should have_selector("input[name='user[name]'][type='text']")
				end

				it "should have email field" do
						get :new
						response.should have_selector("input[name='user[email]'][type='text']")
				end

				it "should have password field" do
						get :new
						response.should have_selector("input[name='user[password]'][type='password']")
				end

				it "should have password confirmation field" do
						get :new
						response.should have_selector("input[name='user[password_confirmation]'][type='password']")
				end

		end

		describe "GET 'show'" do

				before do
						@user = Factory(:user)
				end

				it "should be successful" do
						get :show, :id => @user
						response.should be_success
				end

				it "should find the right user" do
						get :show, :id => @user
						assigns(:user).should == @user
				end

				it "should have the right title" do
						get :show, :id => @user
						response.should have_selector("title", :content => @user.name)
				end

				it "should contain user name" do
						get :show, :id => @user
						response.should have_selector("h1", :content => @user.name)
				end

				it "should have user profile image" do
						get :show, :id => @user
						response.should have_selector("h1>img", :class => "gravatar")
				end

		end

		describe "POST 'create'" do
				describe "failure" do
						before do
								@attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
						end

						it "should not create a user" do
								lambda do
										post :create, :user => @attr
								end.should_not change(User, :count)
						end

						it "should have the right title" do
								post :create, :user => @attr
								response.should have_selector("title", :content => "Sign up")
						end

						it "should render the 'new' page" do
								post :create, :user => @attr
								response.should render_template('new')
						end
				end

				describe "success" do
						before do
								@attr = {:name => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar"}
						end

						it "should create user" do
								lambda do
								post :create, :user => @attr
								end.should change(User, :count).by(1)
						end

						it "should redirect to user show page" do
								post :create, :user => @attr
								response.should redirect_to(user_path(assigns(:user)))
						end

						it "should have welcome message" do
								post :create, :user => @attr
								flash[:success].should =~ /welcome to the sample app/i
						end
				end
		end

end
