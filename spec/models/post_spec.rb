# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  
  describe 'バリデーションのテスト' do
    subject { post.valid? }
    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id)}

    context 'petカラム' do
      it '空欄ではないこと' do
        post.pet = ''
        is_expected.to eq false
      end
    end
    context 'bodyカラム' do
      it '空欄ではないこと' do
        post.body = ''
        is_expected.to eq false
      end
      it '２００文字以下であること：２００文字は○' do
        post.body = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '２００文字以下であること：２０１文字は×' do
        post.body = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
    context 'post_image_idカラム' do
      it '空欄ではないこと' do
        post.post_image_id = ''
        is_expected.to eq false
      end
    end
  end
  
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1対Nとなっているか' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Commentモデルとの関係' do
      it '1対Nとなっているか' do
        expect(Post.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Favoriteモデルとの関係' do
      it '1対Nとなっているか' do
        expect(Post.reflect_on_association(:favorites).macro).to eq :has_many
      end
      it 'いいねしてくれたユーザーと1対Nになっているか' do
        expect(Post.reflect_on_association(:favorited_users).macro).to eq :has_many
      end
    end
    context 'Notificationモデルとの関係' do
      it '1対Nとなっているか' do
        expect(Post.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end