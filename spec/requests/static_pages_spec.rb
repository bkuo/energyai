require 'spec_helper'

describe "StaticPages" do
	
	let (:base_title) { "Verdigristech Energy.AI" }
	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector('img', alt: heading) }
		it { should have_selector('title', text: full_title(page_title)) }
	end

	describe "Home Page and Sign in" do
		#before(:each) { visit root_path }
		before(:each) { visit root_path }
		let(:heading) { 'Energy.AI' }
		let(:page_title) { 'Sign in' }

		it_should_behave_like "all static pages"
		
		# all the right links should exist in the footer
		it { should have_link("About Verdigris", href: aboutus_path) }
	    it { should have_link("Help", href: help_path) }
		it { should have_link("Blog", href: blog_path) }
	    it { should have_link("Terms", href: terms_path) }
	    
	    it { should have_link("Sign up", href: signup_path) } 
	    it { should_not have_selector('header') } 
	    it { should_not have_selector('footer') }  	
		it { should have_link("Sign in with Google Account", href: '#') }
		# it should have normal signin form
		it { should have_content('Email')}
		it { should have_content('Password')}
	end


end
