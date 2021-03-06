class Item < ActiveRecord::Base

  attach_vendor
  explicit_integer :value
  acts_as_taggable

  belongs_to :recurring
  belongs_to :user
  
  has_one    :paycheck,  :dependent=>:nullify
  
  named_scope :during, lambda { |date| {:conditions=>{:date=>date}} }
  named_scope :on,     lambda { |date| {:conditions=>{:date=>date}} }
  
  before_validation :amortize, :if=>:date
  def amortize
    self.start  = date unless start
    self.finish = date unless finish
    self.start, self.finish = finish, start if start > finish
    self.per_diem = value / ((finish - start).to_i + 1)
    true # Never halt
  end
  
  attr_accessible :date, :description, :finish, :explicit_value, :paycheck, :start, :tag_list
  
  validates_presence_of     :date, :user_id
  validates_numericality_of :value, :only_integer=>true

end
