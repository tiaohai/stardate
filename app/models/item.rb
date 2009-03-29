class Item < ActiveRecord::Base

  attach_vendor
  explicit_integer :value
  acts_as_taggable

  belongs_to :recurring
  belongs_to :user
  
  has_one    :paycheck,  :dependent=>:nullify
  
  named_scope :during, lambda { |date| {:conditions=>{:date=>date}} }
  named_scope :on,     lambda { |date| {:conditions=>{:date=>date}} }
  
  attr_accessible :date, :description, :end, :explicit_value, :paycheck, :per_diem, :start, :tag_list
  
  validates_presence_of     :date, :user_id
  validates_numericality_of :value, :only_integer=>true

end
