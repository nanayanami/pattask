class CommentsController < ApplicationController
    def create
        @team = Team.find(params[:team_id])
        @category = @team.categories.find(params[:category_id])
        @post = @category.posts.find(params[:post_id])
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
        @comment = Comment.find(params[:id])
        @comment.destroy
        redirect_to team_category_post_path(params[:team_id], params[:category_id], @comment.post),
                    notice: 'コメントを削除'
    end

    private

    def comment_params
        params.require(:comment).permit(:comment)
    end

    def set_post
        @post = Post.find(params[:post_id])
    end

    def set_comment
        @comment = @post.comments.find(params[:id])
    end
end
