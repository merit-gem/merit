require 'test_helper'

describe Merit::RulesMatcher do

  describe 'rules actions are treated as a regexp' do
    it 'selects matching rules (suffix)' do
      matcher = Merit::RulesMatcher.new('comments', 'update')
      selected = matcher.select_from(
        'comments#update' => 'comments#update',
        'comments#up'     => 'comments#up',
        'comments#up$'   => 'comments#up$',
        'comments#up.+$' => 'comments#up.+$',
      )
      _(selected).must_be :==, ['comments#update', 'comments#up.+$']

      matcher = Merit::RulesMatcher.new('comments', 'up')
      selected = matcher.select_from(
        'comments#update' => 'comments#update',
        'comments#up'     => 'comments#up',
        'comments#up$'   => 'comments#up$',
        'comments#up.+$' => 'comments#up.+$',
      )
      _(selected).must_be :==, ['comments#up', 'comments#up$']
    end

    it 'selects matching rules (prefix)' do
      matcher = Merit::RulesMatcher.new('/posts/1/comments', 'create')
      selected = matcher.select_from(
        'comments#create' => 'comments#create',
        '^comments#create' => '^comments#create',
        '^.*/comments#create' => '^.*/comments#create',
      )
      _(selected).must_be :==, ['^.*/comments#create']
    end
  end

end
