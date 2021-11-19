# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Commentモデルのテスト', type: :model do
   describe 'バリデーションのテスト' do
    subject { comment.valid? }
    let(:user) { create(:user) }
    let(:post) { build(:post, user_id: user.id) }
    let!(:comment) { build(:comment, user_id: user.id, post_id: post.id) }

    context 'commentのカラム' do
      it '空欄でないこと' do
        comment.comment = ''
        is_expected.to eq false
      end
      it '１００文字以下であること：１００文字は◯' do
        comment.comment = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '１００文字以下であること：１０１文字は×' do
        comment.comment = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end
  
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1対Nとなっている' do
        expect(Comment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Postモデルとの関係' do
      it '1対Nとなっている' do
        expect(Comment.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context 'Notificationモデルとの関係' do
      it '1対Nとなっている' do
        expect(Comment.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end