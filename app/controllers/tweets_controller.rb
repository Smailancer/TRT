class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, except: [:create]

  def create
    @tweet = current_user.tweets.new(tweet_params)
    if @tweet.save 
      @tweet.create_activity key: 'tweet.created', owner: @tweet.user 
      redirect_to user_path(@tweet.user.username), notice: "Tweeted"
    else
      redirect_to user_path(@tweet.user.username), notice: 'Somthing went wrong'
    end
  end

  def edit
  end

  def update
    if @tweet.update(tweet_params)
      redirect_to user_path(@tweet.user.username), notice: "Tweet Updated"
    else 
      redirect_to user_path(@tweet.user.username), notice: "Somthing updated"
    end
  end

  def destroy
    @tweet.destroy
    redirect_to  user_path(@tweet.user.username), notice: "Tweet deleted"
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end
end
