require 'test_helper'

describe Merit::Action do
  it 'saves correctly with a serialised model' do
    comment = Comment.new(name: 'the comment name')
    action = Merit::Action.create(target_model: 'comment',
                                  target_id: 2,
                                  target_data: comment.to_yaml)
    comment_yaml = Merit::Action.find(action.id).target_data
    assert_equal comment.name, YAML::load(comment_yaml).name
  end
end
