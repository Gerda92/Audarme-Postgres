class Word < ActiveRecord::Base
  attr_accessible :definition, :language, :name
end
