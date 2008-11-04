require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  define_models
  before { @user = users(:default) }
  
  #####################################################################
  #                      C L A S S     M E T H O D S                  #
  #####################################################################
  it 'should not authenticate an nil email' do
    User.authenticate(nil, 'password').should be_nil
  end

  it 'should not authenticate a blank password' do
    User.authenticate('default@email.com', '').should be_nil
  end

  it 'should authenticate a valid email/password pair' do
    User.authenticate('default@email.com', 'test').should == @user
  end

  it 'should not authenticate an invalid email/password pair' do
    User.authenticate('default@email.com', 'invalid').should be_nil
  end

  #####################################################################
  #                     R E L A T I O N S H I P S                     #
  #####################################################################
  it 'should have many items' do
    @user.should have(1).items
  end

  it 'should have many jobs' do
    @user.should have(1).jobs
  end
  
  it 'should have many notes' do
    @user.should have(1).notes
  end

  it 'should have many recurrings' do
    @user.should have(1).recurrings
  end

  it 'should have many tasks' do
    @user.should have(3).tasks
  end

  #####################################################################
  #                   O B J E C T S   M E T H O D S                  #
  #####################################################################
  # totaling
  it 'should total on a date' do
    @user.total_on(Date.new(2008, 1, 1)).should == -10
  end

  it 'should total for the week' do
    @user.total_past_week(Date.new(2008, 1, 1)).should == -10
  end

  it 'should total this month' do
    @user.total_past_month(Date.new(2008, 1, 1)).should == -10
  end

  it 'should total this year' do
    @user.total_past_year(Date.new(2008, 1, 1)).should == -10
  end

  # summing
  it 'should sum income from a range' do
    @user.sum_income(Date.new(2008, 1, 1)..Date.new(2008, 1, 15)).should == 0
  end

  it 'should sum income from a date' do
    @user.sum_income(Date.new(2008, 1, 1)).should == 0
  end

  it 'should sum expenses from a range' do
    @user.sum_expenses(Date.new(2008, 1, 1)..Date.new(2008, 1, 15)).should == -10
  end

  it 'should sum expenses from a date' do
    @user.sum_expenses(Date.new(2008, 1, 1)).should == -10
  end

  #####################################################################
  #                        C A L L B A C K S                          #
  #####################################################################
  it 'should encrypt password on save' do
    user = User.create :email=>'new@user.com', :time_zone=>'Pacific Time (US & Canada)',
          :password=>'password', :password_confirmation=>'password'
    user.password_hash.should_not be_blank
    user.password_salt.should_not be_blank
  end

  #####################################################################
  #                      V A L I D A T I O N S                        #
  #####################################################################
  it 'should require password confirmation' do
    user = User.new :password=>'test'
    user.should have(1).error_on(:password_confirmation)
  end

  it 'should have at least a 4 char password' do
    user = User.new :password=>'cat'
    user.should have(1).error_on(:password)
  end

  it 'should have a valid email address' do
    user = User.new :email=>'invalid'
    user.should have(1).error_on(:email)
  end

  it 'should have a unique email' do
    user = @user.clone
    user.should have(1).error_on(:email)
  end

  it 'should have a time zone' do
    User.new.should have(1).error_on(:time_zone)
  end

  #####################################################################
  #                       P R O T E C T I O N                         #
  #####################################################################
  it 'should not update password hash through mass assignment' do
    @user.update_attributes :password_hash=>'new hash'
    @user.reload.password_hash.should_not == 'new hash'
  end

  it 'should not update password salt through mass assignment' do
    @user.update_attributes :password_salt=>'new salt'
    @user.reload.password_salt.should_not == 'new salt'
  end

  #####################################################################
  #                       D E S T R U C T I O N                       #
  #####################################################################
  it 'should delete items on destroy' do
    running { @user.destroy }.should change(Item, :count).by(-1)
  end

  it 'should delete jobs on destroy' do
    running { @user.destroy }.should change(Job, :count).by(-1)
  end
  
  it 'should delete notes on destroy' do
    running { @user.destroy }.should change(Note, :count).by(-1)
  end

  it 'should delete recurrings on destroy' do
    running { @user.destroy }.should change(Recurring, :count).by(-1)
  end
  
end