class FriendsController < ApplicationController
  def index
    @users   = User.where.not(id: current_user.id)
    @friends = Friendship.
      where('from_id = ? OR to_id = ?', current_user.id, current_user.id).
      to_a.
      index_by { |f| f.from_id == current_user.id ? f.to_id : f.from_id }
  end

  def create
    to = User.find params[:user_id]
    Friendship.where(from: current_user, to: to).first_or_create!
    redirect_back fallback_location: friends_path
  end

  def approve
    friendship = Friendship.find_by! from_id: params[:id], to: current_user
    friendship.update! approved_at: Time.now
    redirect_back fallback_location: friends_path
  end
end
