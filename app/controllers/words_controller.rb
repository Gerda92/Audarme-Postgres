class WordsController < ApplicationController
  def index
    @adverts = Advert.get_adverts
    @show = true
    render :define
  end

  def define
    @word = Word.where(:language => params['lang'], :name => params['name']).first
    if (@word.nil?)
      if params['lang'] == 'kz'
        @variants = Lemmatizer.lemmatize params['name']
      end
      if @variants
        @variants.each do |v|
          @w = Word.where(:language => params['lang'], :name => v).first
          if @w
            @word = @w
          end
        end
      end
    end
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

    response.headers["Access-Control-Allow-Methods"] = "GET, PUT, POST, DELETE"
    response.headers["Access-Control-Allow-Headers"] = "*"
    response.headers['Access-Control-Allow-Origin'] = '*'

    respond_to do |format|
      format.html { render :json => @word }
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

    response.headers["Access-Control-Allow-Methods"] = "GET, PUT, POST, DELETE"
    response.headers["Access-Control-Allow-Headers"] = "*"
    response.headers['Access-Control-Allow-Origin'] = '*'

    @suggestions = Word.order(:indexed_name)
      .where(:language => params['lang'])
      .find(:all, :conditions => ['name LIKE ? ', ''+params[:name]+'%'],:limit => 10)
=begin
	if params['lang'] == 'kz' && @suggestions.empty?
		Lemmatizer.lemmatize(params[:name]).each do |lemma|
			if Word.where(language: lang, name: lemma).all.count > 0
				@suggestions << lemma
			end
		end
	end
=end	  
    render :json => @suggestions
  end

  def nearby
    @word = Word.where(:language => params['lang'], :name => params['name']).first
    @lower = Word.where(:language => params['lang']).order(:indexed_name)
      .find(:all, :conditions => ['indexed_name > ? ', @word.indexed_name],:limit => 4)
    @upper = Word.where(:language => params['lang']).find(:all, :order => 'indexed_name desc',
      :conditions => ['indexed_name <= ? ', @word.indexed_name],:limit => 4).reverse
    render :json => @upper + @lower
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

  def lem
    raise Lemmatizer.lemmatize(params[:word]).inspect
  end

  def examples
  end

  def about_us
  end

  def contact_us
  end

end
