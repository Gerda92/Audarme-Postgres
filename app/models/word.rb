class Word < ActiveRecord::Base

  attr_accessible :definition, :language, :name, :indexed_name

  before_create do |word|
  	word.indexed_name = Parser.indexed_name(word.name)
  end

end
