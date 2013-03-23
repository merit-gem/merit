module CommentVotingHelpers

  def vote_comment(comment, options={})
    within "tr#c_#{comment.id}" do
      click_link options[:points].to_s
    end
  end

end
