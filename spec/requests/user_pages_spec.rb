require 'spec_helper'

describe "UserPages" do
  subject { page }
  describe "signup page" do
    before {visit signup_path}
    it { should have_selector('h1',text:'Sign up') }
    it { should have_selector('title',text:full_title('Sign up')) }
  end


  describe 'profile page' do

    let :user do
      FactoryGirl.create(:user)
    end

    before {visit user_path(user)}

    it { should have_selector('h1',text: user.name) }
    it { should have_selector('title',text:user.name) }
  end

  describe 'create a new user by form' do
    before do 
      visit signup_path
    end

    let :submit do
      'Create my account'
    end

    describe 'invalid information by submit' do
      it 'should not create a user ' do
        expect do 
          click_button submit 
        end.should_not change(User,:count)
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'user_name', with:'xiaofei1'
        fill_in 'Email', with:'xiaofei1@163.com'
        fill_in 'Password', with:'xiaofei1'
        fill_in 'Confirmation', with:'xiaofei1'
      end
      it 'should create a user' do
        expect do
          click_button submit
        end.should change(User,:count).by(1)
      end
      describe 'after save user' do
        before {click_button submit}
        it {should have_link('Sign out') }
        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end

    end
  end


end
