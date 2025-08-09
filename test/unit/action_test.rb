require 'test_helper'

describe Merit::Action do
  it 'saves correctly with a serialised model' do
    comment = Comment.new(name: 'the comment name')
    action = Merit::Action.create(target_model: 'comment',
                                  target_id: 2,
                                  target_data: JSON.generate(comment.as_json))
    comment_json = Merit::Action.find(action.id).target_data
    assert_equal comment.name, JSON.parse(comment_json)['name']
  end
end
