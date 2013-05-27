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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before {sign_in user }
    before { visit edit_user_path(user) }

    describe "page" do
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }

    end
  end

  describe "index" do
    let(:user) {FactoryGirl.create(:user)}
    before do
      sign_in user 
      #FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      #FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1', text: 'All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it {should_not have_link("delete")}
      describe "as an admin user" do

        let(:admin){FactoryGirl.create(:admin)}
        before do
          sign_in admin
          visit users_path
        end

        it {should have_link('delete',href: user_path(User.first))}
        it "should be able to delete another user" do
          expect {click_link('delete')}.to change(User,:count).by(-1)
        end
        it {should_not have_link('delete',href: user_path(admin))}
      end
    end



  end


end
