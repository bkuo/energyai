require 'spec_helper'

describe "AuthenticationPages" do

	subject { page }	

	describe "signin page" do
		before { visit signin_path }

		it { should have_selector('title',  text: 'Sign in') }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { click_button "Sign in" }

			it { should have_selector('title', text: 'Sign in') }
			it { should have_error_message('Invalid') }
			it { should_not have_link('My Account', href: user_path(user)) }
 			it { should_not have_link('Settings', href: edit_user_path(user)) }

			describe "after visiting another page" do
				before  { click_link 'Energy.AI' }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { valid_signin(user) }

 			it { should have_selector('title', text: user.name) }
 			it { should have_link('Users',   href: users_path) }
 			it { should have_link('My Account', href: user_path(user)) }
 			it { should have_link('Settings', href: edit_user_path(user)) }
 			it { should have_link('Sign out', href: signout_path) }
 			it { should_not have_link('Sign in', href: signin_path) }

 			pending { should have_link('My Buildings',   href: '#') } #update with real path
			pending { should have_link('Alert Settings', href: '#') } #update with real alerts.			
			# for each recent buildings |building| do
			pending { should have_link(building.name, href: '#') } # update with dashboard path for building.

 			describe "followed by signout" do
 				before { click_link "Sign out" }
 				it { should have_link('Sign in') }
	 			it { should_not have_link('Sign out', href: signout_path) }
	 			it { should_not have_link('Settings', href: edit_user_path(user)) }
 			end
 		end
	end

	describe "authorization" do

		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					sign_in(user)
				end

				describe "after signing in" do

					it "should render the desired protected page" do
						page.should have_selector('title', text: "Edit #{user.name}")
					end

					describe "when signing in again" do
						before do
							visit signin_path
							sign_in(user)
						end

						it "should render the default profile page" do
							page.should have_selector('title', text: user.name)
						end
					end
				end
			end
				
			describe "in the Users controller" do

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_selector('title', text: 'Sign in') }
				end

				describe "submitting to the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end

				describe "visiting the user index" do
					before { visit users_path }
					it { should have_selector('title', text: 'Sign in') }
				end
			end

			describe "in the Microalerts controller" do

				describe "submitting to the create action" do
					before { post microalerts_path }
					specify { response.should redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before { delete microalert_path(FactoryGirl.create(:microalert)) }
					specify { response.should redirect_to(signin_path) }
				end
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user }

			describe "visiting Users#edit page" do
				before { visit edit_user_path(wrong_user) }
				it { should_not have_selector('title', text: full_title("Edit #{wrong_user.name}")) }
			end

			describe "submitting a PUT request to the Users#update action" do
				before { put user_path(wrong_user) }
				specify { response.should redirect_to(root_path) }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) {FactoryGirl.create(:user) }

			before { sign_in non_admin }
			
			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { response.should redirect_to(root_path) }
			end
		end

		describe "as an admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:admin) { FactoryGirl.create(:admin) }

			before {sign_in admin }

			it "shouldn't be able to self destruct on DELETE request" do
				expect { delete user_path(admin) }.not_to change(User, :count).by(-1)
			end
		end
 	end
end