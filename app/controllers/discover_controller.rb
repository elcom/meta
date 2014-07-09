class DiscoverController < ApplicationController

  def staff_picks
    @week = Date.today
    slugs = (ENV['STAFF_PICKS'] || '').split(',')
    staff_picks = Product.where(slug: slugs).sort_by{|p| slugs.index(p.slug)}
    @products = (staff_picks + Showcase.this_weeks_products).uniq.take(10)
  end

  def trending
    @products = Product.public_products
                       .joins(:product_trend)
                       .where('votes_count >= ?', 10)
                       .order('product_trends.score desc')
                       .limit(10)
  end

  def most_wanted
    @products = Product.public_products
                       .where('votes_count >= ?', 5)
                       .order(votes_count: :desc)
                       .page(params[:page])
  end

  def no_commits
    @products = Product.public_products
                       .repos_gt(0)
                       .where(commit_count: 0)
                       .order(votes_count: :desc)
                       .page(params[:page])
  end

  def tech
    @tech = Search::TechFilter.find(params[:tech])
    if signed_in?
      @saved_search = current_user.saved_searches.find_by(query: "tag:#{params[:tech]}")
    end
    @products = Product.public_products
                       .where('votes_count >= ?', 5)
                       .tagged_with_any(@tech.tags)
                       .order(votes_count: :desc)
                       .page(params[:page])

    @needing_commit = Product.public_products
                       .repos_gt(0)
                       .where('votes_count >= ?', 3)
                       .where(commit_count: 0)
                       .order("Random()")
                       .limit(2)
  end

end
