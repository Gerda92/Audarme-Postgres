class WordsController < ApplicationController
  def index
    render :define
  end

  def define
    @word = Word.where(:language => params['lang'], :name => params['name']).first
    if (@word.nil?)
      if (request.xhr?)
        render :json => 'Error'
      else
        render :define
      end
      return
    end
    other_lang = params['lang'] == 'kz'? 'ru' : 'kz'
    #@word.definition.gsub!(/(<a[^>]*href=")[^"]*("[^>]*>)(.*)(<\/a>)/ix, '\1/words/'+ other_lang +'/\3\2\3\4')
    respond_to do |format|
      format.html { render :define }
      format.json { render :json => @word }
    end
  end

  def try_api
    respond_to do |format|
      format.html {}
      format.json {}
    end
  end
	
  def define_ru
	@word = Word.where(:language => params['lang'], :name => params['name']).first
   	if (@word.nil?)
		if (request.nil?)
			render :json => 'Error'
		else
			render :define
		end
		return
	end
    other_lang = params['lang'] == 'kz'? 'ru' : 'kz'
    respond_to do |format|
	format.html {render :define}
        format.json {render:json => @word}
    end
  end

  def suggest
    @suggestions = Word.order(:indexed_name).where(:language => params['lang']).find(:all, :conditions => ['name LIKE ? ', ''+params[:name]+'%'],:limit => 10)

    render :json => @suggestions
  end

  def add_word_kz
    @word = Word.new
    @word.name = params['name']
    @word.language = 'kz'
    @word.definition = params['definition']
    @check = Word.where(name: @word.name).all.to_a
    if (@check.count == 0)
      @word.save
    end
  end

  def add_word_ru
    @word = Word.new
    @word.name = params['name']
    @word.language = 'ru'
    @word.definition = params['definition']
    @check = Word.where(name: @word.name).all.to_a
    if (@check.count == 0)
      @word.save
    end
  end

  def word_exist
    @name = params['name']
    @word = Word.where(name: @name).all.to_a
    if (@word.count == 0)
      return false
    else 
      return true
    end
  end

end
