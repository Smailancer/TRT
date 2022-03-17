class RetweetsController < ApplicationController
  before_action :authenticate_user!

  def create
    retweet = current_user.retweets.new(source_tweet_id: params[:tweet_id])
    if retweet.save
      retweet.create_activity key: 'retweet.created', owner: current_user, recipient: retweet.source_tweet.user
      redirect_to user_path(current_user.username), notice: 'Retweeted'
    else 
      redirect_back fallback_location: root_path, alert: "You can't retweet twice"
    end
  end

  def destroy
    retweet = current_user.retweets.find(params[:id])
    retweet.destroy
    redirect_to user_path(current_user.username), notice: 'Retweet Deleted'
  end
end
