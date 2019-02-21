class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def vote
    @comment = Comment.find(params[:id])
    @comment.votes += params[:value].to_i
    @comment.save
    redirect_to(comments_url, :notice => 'Vote added!')
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to(@comment, :notice => 'Comment was successfully created.')
    else
      render "new"
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to(@comment, :notice => 'Comment was successfully updated.')
    else
      render "edit"
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to(comments_url)
  end

  private

  def comment_params
    params.require(:comment).permit!
  end
end
