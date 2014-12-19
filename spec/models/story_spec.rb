require 'spec_helper'

describe Story do
  describe 'reader_ids' do
    let(:product) { task.product }
    let(:follower) { User.make! }
    let(:nfi) { NewsFeedItem.make! }
    let(:task) { Task.make!(news_feed_item: nfi) }

    it 'should be the product if that is the target' do
      product.followers << follower

      activity = Activities::Start.make!(subject: task, target: product)
      story = Story.create!(
        verb: activity.verb,
        subject_type: activity.verb_subject,
        activities: [activity]
      )
      expect(story.reader_ids).to match_array([follower.id])
    end

    it 'should be the nfi if the target is not the product' do
      nfi.followers << follower
      nfi.comments.create!(user: follower, body: 'sup')

      story = Story.make!(activities: [Activities::Start.make!(target: task)])
      expect(story.reader_ids).to include(follower.id)
    end
  end
end