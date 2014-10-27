class NewsFeedItemsController < ProductController
  before_action :find_product!

  def index
    @news_feed_items = ActiveModel::ArraySerializer.new(
      @product.news_feed_items.order(updated_at: :desc)
    ).as_json
  end

  def popularize
    @news_feed_item = NewsFeedItem.find(params[:update_id])
    @news_feed_item.update!(popular_at: Time.now)
    render nothing: true, status: 200
  end

  def depopularize
    @news_feed_item = NewsFeedItem.find(params[:update_id])
    @news_feed_item.update!(popular_at: nil)
    render nothing: true, status: 200
  end

end
