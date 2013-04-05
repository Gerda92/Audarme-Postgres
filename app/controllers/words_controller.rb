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
    @word.definition.gsub!(/(<a[^>]*href=")[^"]*("[^>]*>)(.*)(<\/a>)/ix, '\1/words/'+ other_lang +'/\3\2\3\4')
    respond_to do |format|
      format.html { render :define }
      format.json { render :json => @word }
    end
  end

  def suggest
    @suggestions = Word.order(:name).where(:language => params['lang']).find(:all, :conditions => ['name LIKE ? ', ''+params[:name]+'%'],:limit => 10)

    render :json => @suggestions
  end

end