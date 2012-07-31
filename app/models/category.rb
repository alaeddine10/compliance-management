class Category < ActiveRecord::Base
  scope :ctype, lambda { |sid| where(:scope_id => sid) }
  acts_as_nested_set :scope => :scope_id

  attr_accessible :name, :scope_id

  has_many :categorizations, :dependent => :destroy
  has_many :controls, :through => :categorizations,
    :source => :stuff, :source_type => 'Control'
end
