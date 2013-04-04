class WordsController < ApplicationController
  def index
    text = ''
    Word.order(:name).limit(10).each { |w|
      text += '<h2>' + w.name + '</h2><p>' + (w.definition.nil? ? '' : w.definition) + '</p>'

    }
    render :text => '<h1>' + Word.all.count.to_s + '</h1>' + text
  end

  def define
    @word = Word.where(:language => params['lang'], :name => params['name']).first
    other_lang = params['lang'] == 'kz'? 'ru' : 'kz'
    @word.definition.gsub!(/(<a[^>]*href=")[^"]*("[^>]*>)(.*)(<\/a>)/ix, '\1/words/'+ other_lang +'/\3\2\3\4')
    respond_to do |format|
      format.html { render :define }
      format.json { render :json => @word }
    end
  end

  def suggest
    #@suggestions = Word.order(:name).where(:name => /^#{params[:name]}/m).limit(10)
    @suggestions = Word.order(:name).find(:all, :conditions => ['name LIKE ? ', ''+params[:name]+'%'],:limit => 10)
=begin
    text = ''
    @suggestions.each { |w|
      text += '<h2>' + w.name + '</h2><p>' + (w.definition.nil? ? '' : w.definition) + '</p>'

    }
    render :text => '<h1>' + @suggestions.count.to_s + '</h1>' + text
=end
    render :json => @suggestions
  end

end