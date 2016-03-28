require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(name: "Example User", email: "user@example.com",
						 password: "foobar", password_confirmation: "foobar")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = "   "
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = "   "
		assert_not @user.valid?
	end

	test "name should not be too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	test "email validation should accept valid address" do
		invalid_addresses = %w[user@example,com USER_at_foo.COM user.name@example.
								foo@bar_baz.com foo@bar+baz.com]
		invalid_addresses.each do |invalid_address|
			@user.email = invalid_address
			assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
		end
	end

	test "email addresses should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "password should be present (nonblank)" do
		@user.password = @user.password_confirmation = " " * 6
		assert_not @user.valid?
	end

	test "password should have a minimim length" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end

	test "authenticated? should return false for a user with nil digest" do
		assert_not @user.authenticated?(:remember, '')
	end

	test "associated microposts should be destroyed" do 
		@user.save
		@user.microposts.create!(content: "Lorem ipsum")
		assert_difference 'Micropost.count', -1 do
			@user.destroy
		end
	end

	test "should follower and unfollow a user" do 
		thomas = users(:thomas)
		archer = users(:archer)
		assert_not thomas.following?(archer)
		assert archer.followers.include?(thomas)
		thomas.follow(archer)
		assert thomas.following?(archer)
		assert_not thomas.following?(archer)
	end
end

