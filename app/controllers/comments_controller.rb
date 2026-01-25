class CommentsController < ApplicationController
    before_action :set_team
    before_action :set_category
    before_action :set_post
    before_action :set_comment, only: [:destroy]

    def create
        @comment = @post.comments.build(comment_params)
        @comment.user_id = current_user.id
        if @comment.save
            redirect_to team_category_post_path(@team, @category, @post),
                        notice: 'コメントを作成'
        else
            @comments = @post.comments.page(params[:page]).per(7).reverse_order
            render "posts/show", status: :unprocessable_entity
        end
    end

    def destroy
        @comment.destroy
        redirect_to team_category_post_path(@team, @category, @comment.post),
                    notice: 'コメントを削除'
    end

    private

    def comment_params
        params.require(:comment).permit(:comment)
    end

    def set_team
        @team = Team.find(params[:team_id])
    end

    def set_category
        @category = @team.categories.find(params[:category_id])
    end

    def set_post
        @post = @category.posts.find(params[:post_id])
    end

    def set_comment
        @comment = Comment.find(params[:id])
    end
end
