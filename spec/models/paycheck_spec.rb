require File.dirname(__FILE__) + '/../spec_helper'

#####################################################################
#                     R E L A T I O N S H I P S                     #
#####################################################################
describe Paycheck, 'relationships' do
  
  before(:each) do
    @paycheck = paychecks(:starbucks_last_week)
  end
  
  it 'should belong to a user' do
    @paycheck.item.should == items(:starbucks_last_week)
  end
  
  it 'should belong to a job' do
    @paycheck.job.should == jobs(:starbucks)
  end
  
  it 'should have many tasks' do
    @paycheck.should have(5).tasks
  end
end

#####################################################################
#                               S C O P E                           #
#####################################################################
describe Paycheck, 'scope' do
  it 'should find unpaid' do
    Paycheck.should have(1).unpaid
  end
end

#####################################################################
#                    O B J E C T    M E T H O D S                   #
#####################################################################
describe Paycheck do
  
  it 'should have a paid? attribute based on item' do
    paychecks(:risi_last_month).should_not be_paid
    paychecks(:starbucks_last_week).should be_paid
  end
  
  it 'should set paid attribute with boolean' do
    paycheck = Paycheck.new :paid=>false
    paycheck.should_not be_paid
    paycheck.paid = true
    paycheck.should be_paid
  end
  
  it 'should set paid attribute with an integer (a la form set)' do
    paycheck = Paycheck.new :paid=>0
    paycheck.should_not be_paid
    paycheck.paid = 1
    paycheck.should be_paid
  end
  
  it 'should create an item on save if paid is set and no previous item' do
    paycheck = paychecks(:risi_last_month)
    paycheck.paid = true
    running {
      paycheck.save
      paycheck.item.should_not be_nil
    }.should change(Item, :count).by(1)
  end
  
end

#####################################################################
#                       V A L I D A T I O N S                       #
#####################################################################
describe Paycheck, 'validations' do
  
  it 'should have a job_id' do
    Paycheck.new.should have(1).error_on(:job_id)
  end
  
  it 'should have a numeric value' do
    Paycheck.new(:value=>'not numeric').should have(1).error_on(:value)
  end
  
  it 'should have an item and job belong to same person' do
    paycheck = paychecks(:risi_last_month)
    paycheck.item = items(:starbucks_last_week)
    paycheck.should have(1).error_on(:item)
  end
end

#####################################################################
#                       D E S T R U C T I O N                       #
#####################################################################
describe Paycheck, 'destruction' do
  
  it 'should nullify tasks' do
    paychecks(:starbucks_last_week).destroy
    tasks(:starbucks_one).paycheck.should be_nil
  end
  
end