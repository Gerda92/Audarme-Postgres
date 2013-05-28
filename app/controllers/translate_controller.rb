class WordsController < ApplicationController
  def index
    render :define
  end

  def ru word
    @word = Word.where(:language => 'kz', :name => word).first
    if (@word.nil?)
      if (request.xhr?)
        render :json => 'Error'
      else
        render :define
      end
      return
    end
    respond_to do |format|
      format.html { render :define }
      format.json { render :json => @word }
    end
  end

  def kz
    @word = Word.where(:language => 'ru', :name => word).first
    if (@word.nil?)
      if (request.xhr?)
        render :json => 'Error'
      else
        render :define
      end
      return
    end
    respond_to do |format|
      format.html { render :define }
      format.json { render :json => @word }
    end
  end

end