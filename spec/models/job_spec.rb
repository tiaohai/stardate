require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe Job, 'relationships' do
  
  before(:each) do
    @job = jobs(:starbucks)
  end
  
  it 'should belong to a user' do
    @job.user.should == users(:scott)
  end
  
  it 'should have many paychecks' do
    @job.paychecks.should == [paychecks(:last_week)]
  end
  
  it 'should have many tasks' do
    @job.tasks.should == [tasks(:today_shift)]
  end
end

#####################################################################
#                               S C O P E                           #
#####################################################################
describe Job, 'scope' do
  it 'should find active' do
    Job.active.size.should == 3
  end
end

#####################################################################
#                         P R O T E C T I O N                       #
#####################################################################
describe Job, 'protections' do
  
  before(:each) do
    @job = jobs(:risi)
  end
  
  it 'should not update user_id through mass assignment' do
    @job.update_attributes :user_id=>users(:scott).id
    @job.user_id.should_not == users(:scott).id
  end
  
  it 'should not update user through mass assignment' do
    @job.update_attributes :user=>users(:scott)
    @job.user.should_not == users(:scott)
  end
end

#####################################################################
#                       V A L I D A T I O N S                       #
#####################################################################
describe Job, 'validations' do
  
  it 'should have a name' do
    Job.new.should have(1).error_on(:name)
  end
  
  it 'should have a user_id' do
    Job.new.should have(1).error_on(:user_id)
  end
end

#####################################################################
#                       D E S T R U C T I O N                       #
#####################################################################
describe Job, 'destruction' do
  
  before(:each) do
    @job = jobs(:starbucks)
  end
  
  it 'should destroy paychecks' do
    running { @job.destroy }.should change(Paycheck, :count).by(-1)
  end
  
  it 'should destroy tasks' do
    running { @job.destroy }.should change(Task, :count).by(-1)
  end
end